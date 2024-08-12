class NoticeValue < ApplicationRecord
  belongs_to :notice
  belongs_to :ad_type_field

  has_one_attached :file

  validate :value_validator
  validate :file_validator

  private

  def value_validator
    return if ad_type_field.file?

    errors.add(:value, :presence) and return if ad_type_field.required? && value.blank?

    errors.add(:value, :inclusion) and return if ad_type_field.options? && !ad_type_field.option_values.include?(value)

    begin
      ad_type_field.date? && Date.strptime(value, '%d-%m-%Y')
    rescue Date::Error
      errors.add(:value, :invalid)
    end
  end

  def file_validator
    if ad_type_field.file? && ad_type_field.required? && !file.attached?
      errors.add(:file, "#{ad_type_field.name} este obligatoriu de completat")
    end
  end
end
