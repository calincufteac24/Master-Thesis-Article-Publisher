class AdTypeField < ApplicationRecord
  audited
  validates :name, presence: true
  validates :form_field_type, presence: true
  validates :position, presence: true
  validates :ad_type_id, presence: true

  belongs_to :ad_type

  enum form_field_type: %i[
    text
    date
    time
    cpv
    file
    options
  ]
end
