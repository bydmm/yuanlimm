class AddTimeToUser < ActiveRecord::Migration[5.1]
  def change
    change_table :users do |t|
      t.timestamps
    end
    change_table :stocks do |t|
      t.timestamps
    end
  end
end
