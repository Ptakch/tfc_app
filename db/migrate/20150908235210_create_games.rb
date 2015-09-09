class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :file_name
      t.timestamp :game_date
      t.string :map

      t.timestamps null: false
    end
  end
end
