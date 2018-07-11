class AddLimitToBalance < ActiveRecord::Migration[5.1]
  def change
    change_column :user_stocks, :balance, :integer, :limit => 8
    change_column :user_wallets, :balance, :integer, :limit => 8
  end
end
