class CreateAdTypeStages < ActiveRecord::Migration[6.1]
  def change
    create_table :ad_type_stages do |t|
      t.integer :ad_type_id, null: false, foreign_key: true
      t.integer :stage_id, null: false, foreign_key: true
      t.integer :position, null: false
      t.boolean :create_invoice, null: false, default: false

      t.timestamps
    end
  end
end
