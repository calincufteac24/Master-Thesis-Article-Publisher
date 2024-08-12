class UserPersonalInformation < ApplicationRecord
  belongs_to :user
  has_encrypted :personal_series, :personal_number, :passport_number
  has_one_attached :photo
  encrypts_attached :photo

  attr_accessor :identity_type

  validates :personal_series, presence: true, length: { maximum: 2 }, format: { with: /[A-Z]{2}/ },
                              if: :personal_id?
  validates :personal_number, presence: true, length: { maximum: 10 }, format: { with: /[0-9]{6}/ },
                              if: :personal_id?
  validates :passport_number, presence: true, length: { maximum: 10 }, format: { with: /[0-9]{8}/ },
                              if: :passport_id?

  validates :photo, presence: true, blob: { size_range: 1..2.megabytes }

  private

  def personal_id?
    identity_type.present? && identity_type == 'personal_id'
  end

  def passport_id?
    identity_type.present? && identity_type == 'passport_id'
  end
end
