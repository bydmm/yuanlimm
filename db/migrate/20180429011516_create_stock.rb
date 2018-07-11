class CreateStock < ActiveRecord::Migration[5.1]
  def change
    create_table :stocks, id: false  do |t|
      t.string :code, null: false
      t.string :name
      t.text :avatar
    end

    add_index :stocks, :code, unique: true
  end
end
