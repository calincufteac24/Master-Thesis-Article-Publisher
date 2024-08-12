class CreateAdTypeFields < ActiveRecord::Migration[6.1]
  def change
    create_table :ad_type_fields do |t|
      t.string :name, null: false
      t.integer :ad_type_id, null: false, foreign_key: true
      t.integer :format, null: false
      t.text :help_text
      t.text :text_before
      t.text :text_after
      t.boolean :required, null: false, default: false
      t.integer :position, null: false

      t.timestamps
    end
  end
end
