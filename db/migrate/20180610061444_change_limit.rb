class ChangeLimit < ActiveRecord::Migration[5.2]
  def change
    change_column :transactions, :amount, :integer, :limit => 8
  end
end
