class CreateOrganizations < ActiveRecord::Migration[6.1]
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :fiscal_code, null: false
      t.string :reg_com, null: false
      t.integer :role, null: false, default: 0
      t.timestamps
    end

    create_table :user_organizations do |t|
      t.references :user
      t.references :organization

      t.string :job_title
      t.timestamps
    end

    add_index :organizations, :fiscal_code, unique: true
    add_index :organizations, :role
  end
end
