class Organization < ApplicationRecord
  audited

  has_many :user_organizations, dependent: :destroy
  has_many :users, through: :user_organizations

  enum role: %i[owner orc colaborator extern]

  validates :name, :fiscal_code, :reg_com, presence: true

  validates :contract_number, presence: true, if: :colaborator?
  validates :fiscal_code, uniqueness: true
end
