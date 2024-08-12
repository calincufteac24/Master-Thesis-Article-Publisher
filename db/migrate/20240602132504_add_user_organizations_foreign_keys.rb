class AddUserOrganizationsForeignKeys < ActiveRecord::Migration[6.1]
  def change
    add_foreign_key :user_organizations, :organizations, column: :organization_id
  end
end
