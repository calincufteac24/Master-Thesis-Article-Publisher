class CreateCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.text :description
      t.text :about
      t.boolean :is_primary, default: false
      t.integer :parent_id

      t.timestamps
    end
  end
end
