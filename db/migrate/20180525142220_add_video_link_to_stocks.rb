class AddVideoLinkToStocks < ActiveRecord::Migration[5.1]
  def change
    add_column :stocks, :video_link, :string
  end
end
