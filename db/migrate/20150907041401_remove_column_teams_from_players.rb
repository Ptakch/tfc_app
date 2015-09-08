class RemoveColumnTeamsFromPlayers < ActiveRecord::Migration
  def change
  	remove_column :players, :team, :text
  	add_column :players, :team_id, :integer
  end
end
