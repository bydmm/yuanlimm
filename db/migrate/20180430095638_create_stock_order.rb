class CreateStockOrder < ActiveRecord::Migration[5.1]
  def change
    create_table :stock_orders do |t|
      t.integer :user_id
      t.integer :status
      t.string  :stock_code
      t.integer :price, default: 100
      t.integer :amount, default: 1
      t.integer :finished_amount, default: 0
      t.text  :detail
      t.index [:user_id, :status, :stock_code]
      t.timestamps
    end
  end
end
