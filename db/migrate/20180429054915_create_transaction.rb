class CreateTransaction < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.string  :type
      t.integer :payer_id
      t.integer :payee_id
      t.integer :buy_stock_order_id
      t.integer :sale_stock_order_id
      t.string :stock_code
      t.integer :pay_type
      t.integer :amount, default: 0
      t.text  :detail
      t.index :type
      t.index :payer_id
      t.index :payee_id
      t.index :stock_code
      t.index :pay_type
      t.index :buy_stock_order_id
      t.index :sale_stock_order_id
      t.timestamps
    end
  end
end
