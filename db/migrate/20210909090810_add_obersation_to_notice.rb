class AddObersationToNotice < ActiveRecord::Migration[6.1]
  def change
    change_table :notices do |t|
      t.text :observation
      t.text :options
      t.references :invoiceable, polymorphic: true
    end
  end
end
