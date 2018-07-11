class AddIndexToTransaction < ActiveRecord::Migration[5.2]
  def change
    add_index :transactions, :created_at
  end
end
