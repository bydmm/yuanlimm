class AddBuyPriceToStock < ActiveRecord::Migration[5.2]
  def change
    add_column :stocks, :buy_price, :integer, default: 0, :limit => 8
  end
end
