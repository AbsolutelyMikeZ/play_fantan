class AddDealerAndDefaultsToGames < ActiveRecord::Migration
  def change
    add_column :games, :dealer, :string, :default => '1'
  end
end
