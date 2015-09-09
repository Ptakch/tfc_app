class AddGameTitleToGames < ActiveRecord::Migration
  def change
  	add_column :games, :game_title, :string
  end
end
