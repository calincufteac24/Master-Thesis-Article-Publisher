class CreateNotices < ActiveRecord::Migration[6.1]
  def change
    create_table :notices do |t|
      t.references :ad_type
      t.references :ad_type_stage
      t.references :creator, foreign_key: { to_table: :users }
      t.references :assigned_to, foreign_key: { to_table: :users }
      t.integer :status, default: 0

      t.timestamps
    end

    create_table :notice_values do |t|
      t.references :notice
      t.references :ad_type_field
      t.text :value

      t.timestamps
    end
  end
end
