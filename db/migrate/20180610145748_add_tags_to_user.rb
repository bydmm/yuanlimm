class AddTagsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :stocks, :tags, :text
  end
end
