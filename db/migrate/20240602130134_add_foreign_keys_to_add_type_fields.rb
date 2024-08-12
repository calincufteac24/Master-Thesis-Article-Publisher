class AddForeignKeysToAddTypeFields < ActiveRecord::Migration[6.1]
  def change
    ## ad_type_fields
    add_foreign_key :ad_type_fields, :ad_types, column: :ad_type_id

    ## user_permissions
    add_foreign_key :user_permissions, :users, column: :user_id

    ## user_permissions
    add_foreign_key :user_organizations, :users, column: :user_id

    ## ad_type_stages
    add_foreign_key :ad_type_stages, :ad_types, column: :ad_type_id
    add_foreign_key :ad_type_stages, :stages, column: :stage_id
  end
end
