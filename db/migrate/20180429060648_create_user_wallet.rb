class CreateUserWallet < ActiveRecord::Migration[5.1]
  def change
    create_table :user_wallets do |t|
      t.integer :user_id
      t.integer :balance, default: 0
      t.index :user_id, unique: true
      t.timestamps
    end

  end
end
