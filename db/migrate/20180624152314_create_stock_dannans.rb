class CreateStockDannans < ActiveRecord::Migration[5.2]
  def change
    create_table :stock_dannans do |t|
      t.integer :user_id
      t.string  :stock_code
      t.index [:user_id, :stock_code]
      t.timestamps
    end
  end
end
