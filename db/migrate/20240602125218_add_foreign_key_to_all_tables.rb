class AddForeignKeyToAllTables < ActiveRecord::Migration[6.1]
  def change
    ## notice values
    add_foreign_key :notice_values, :notices, column: :notice_id
    add_foreign_key :notice_values, :ad_type_fields, column: :ad_type_field_id
  end
end
