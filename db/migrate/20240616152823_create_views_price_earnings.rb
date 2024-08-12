class CreateViewsPriceEarnings < ActiveRecord::Migration[6.1]
  def change
    create_view :views_price_earnings
  end
end
