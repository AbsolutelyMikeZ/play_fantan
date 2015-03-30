class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :turn
      t.integer :num_players
      t.boolean :completed

      t.timestamps null: false
    end
  end
end
