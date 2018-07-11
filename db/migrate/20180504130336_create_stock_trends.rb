class CreateStockTrends < ActiveRecord::Migration[5.1]
  def change
    create_table :stock_trends do |t|
      t.integer :trend_type
      t.string  :stock_code
      t.integer :price, default: 100
      t.datetime :datetime
      t.index [:trend_type, :stock_code]
      t.timestamps
    end
  end
end
