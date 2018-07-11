class AddDemoToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :demo, :boolean, default: false
  end
end
