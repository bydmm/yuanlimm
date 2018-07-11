class AddMarketValueToStock < ActiveRecord::Migration[5.2]
  def change
    add_column :stocks, :market_value, :integer, default: 0, :limit => 8
  end
end
