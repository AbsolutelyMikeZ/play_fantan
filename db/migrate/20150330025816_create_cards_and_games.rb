class CreateCardsAndGames < ActiveRecord::Migration
  def change
    create_table :cards_games, id: false do |t|
      t.belongs_to :card, index: true
      t.belongs_to :game, index: true
    end
  end
end
