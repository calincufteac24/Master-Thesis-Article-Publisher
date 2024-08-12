class CreateAdTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :ad_types do |t|
      t.string :name, null: false
      t.text :description
      t.text :about

      t.timestamps
    end
  end
end
