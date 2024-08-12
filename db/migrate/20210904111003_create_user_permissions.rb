class CreateUserPermissions < ActiveRecord::Migration[6.1]
  def change
    create_table :user_permissions do |t|
      t.references :user
      t.integer :permission, null: false
      t.timestamps
    end
  end
end
