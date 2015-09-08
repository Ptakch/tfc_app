class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
    	t.text :name
    	t.text :steam_id
    	t.text :team
    	t.integer :red_kills, :default => 0
    	t.integer :red_deaths, :default => 0
    	t.integer :red_tks, :default => 0
    	t.integer :red_fck, :default => 0
    	t.integer :red_maps, :default => 0
    	t.integer :blue_kills, :default => 0
    	t.integer :blue_deaths, :default => 0
    	t.integer :blue_tks, :default => 0
    	t.integer :blue_touches, :default => 0
    	t.integer :blue_initials, :default => 0
    	t.integer :blue_sgs, :default => 0
    	t.integer :blue_caps, :default => 0
    	t.integer :blue_maps, :default => 0
    	
    	# t.references :team, index: true, foreign_key: true #added this, because forgot player:references

        t.timestamps null: false
    end
  end
end
