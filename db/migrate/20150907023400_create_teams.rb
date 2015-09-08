class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name, :default => "Unassigned"

      t.timestamps null: false
    end
  end
end
