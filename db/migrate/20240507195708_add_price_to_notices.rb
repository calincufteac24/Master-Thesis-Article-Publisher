class AddPriceToNotices < ActiveRecord::Migration[6.1]
  def change
    add_column :notices, :price, :decimal, precision: 10, scale: 2
  end

  def down
    remove_column :notices, :price
  end
end
