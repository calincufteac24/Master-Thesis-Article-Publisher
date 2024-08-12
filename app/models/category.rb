class Category < ApplicationRecord
  audited
  belongs_to :parent, class_name: 'Category', foreign_key: :parent_id, optional: true, inverse_of: :children
  has_many :children, -> { order(name: :asc) }, class_name: 'Category', foreign_key: :parent_id, inverse_of: :parent
  has_many :ad_types, -> { order(name: :asc) }

  validates :name, presence: true

  default_scope -> { order(name: 'ASC') }

  audited

  scope :primary, -> { where(is_primary: true).order(name: 'ASC') }

  def parents_name
    parent_id.present? ? [*parent.parents_name, name] : name
  end
end
