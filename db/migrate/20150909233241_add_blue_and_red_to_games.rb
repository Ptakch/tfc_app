class AddBlueAndRedToGames < ActiveRecord::Migration
  def change
  	add_column :games, :red_team, :string
  	add_column :games, :blue_team, :string
  end
end
