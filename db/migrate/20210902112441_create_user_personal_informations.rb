class CreateUserPersonalInformations < ActiveRecord::Migration[6.1]
  def up
    remove_column :users, :personal_id
    remove_column :users, :passport_id

    create_table :user_personal_informations do |t|
      t.references :user, null: false, foreign_key: true
      t.string :personal_series, limit: 2
      t.string :personal_number, limit: 10
      t.string :passport_number, limit: 15

      t.timestamps
    end
  end

  def down
    drop_table :user_personal_informations

    add_column :users, :personal_id, :string, limit: 20
    add_column :users, :passport_id, :string, limit: 20
  end
end
