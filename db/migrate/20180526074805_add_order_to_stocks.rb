class AddOrderToStocks < ActiveRecord::Migration[5.1]
  def change
    add_column :stocks, :order, :integer, default: 0
  end
end
