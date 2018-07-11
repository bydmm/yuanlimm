class AddNiceNameToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :nick_name, :string
  end
end
