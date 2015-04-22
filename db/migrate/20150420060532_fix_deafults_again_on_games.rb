class FixDeafultsAgainOnGames < ActiveRecord::Migration
  def change
    change_column :games, :completed, :boolean, :default => false
  end
end
