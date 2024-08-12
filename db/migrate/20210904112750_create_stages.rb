class CreateStages < ActiveRecord::Migration[6.1]
  def change
    create_table :stages do |t|
      t.string :name, null: false
      t.text :description
      t.text :about
      t.integer :position, null: false

      t.timestamps
    end
  end
end
