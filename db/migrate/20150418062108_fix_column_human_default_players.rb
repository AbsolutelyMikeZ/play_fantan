class FixColumnHumanDefaultPlayers < ActiveRecord::Migration
  def change
    change_column :players, :human, :boolean, :default => true
  end
end
