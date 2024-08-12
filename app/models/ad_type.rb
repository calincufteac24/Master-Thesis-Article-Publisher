class AdType < ApplicationRecord
  audited
  validates :name, presence: true
  validates :category_id, presence: true

  belongs_to :category
  has_many :ad_type_fields, -> { order(position: :asc) }, dependent: :destroy, inverse_of: :ad_type
  has_many :notices, dependent: :destroy
  has_many :ad_type_stages, dependent: :destroy
end
