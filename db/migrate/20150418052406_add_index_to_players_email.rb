class AddIndexToPlayersEmail < ActiveRecord::Migration
  def change
    add_index :players, :email, unique: true
    add_index :players, :screen_name, unique: true
  end
end
