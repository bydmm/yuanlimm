class AddMusicLinkToStocks < ActiveRecord::Migration[5.1]
  def change
    add_column :stocks, :music_link, :text
  end
end
