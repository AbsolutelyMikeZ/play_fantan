class FixDefaultsOnGames < ActiveRecord::Migration
  def change
    change_column :games, :dealer, :integer
    change_column :games, :turn, :integer, :default => 1
    change_column :games, :completed, :boolean, :default => true
  end
end
