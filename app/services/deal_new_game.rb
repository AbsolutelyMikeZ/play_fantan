class DealNewGame
  def initialize(game)
    @game = game
  end
  
  def deal
    @deck = Card.all
    @deck = @deck.shuffle
    
    i = 0
    i_max = @game.num_players - 1
    @deck.each do |d|
      hand = Hand.create(:lineup_id => @game.lineups[i].id, :card_id => d.id)
      i == i_max ? i = 0 : i += 1
    end
    
    #find hand where game = game and card = 7 diamonds and set it's viable_play to true
    seven_diamonds = Hand.joins(:card).joins(:lineup).where("cards.abbreviation = '7d'").where("lineups.game_id = #{@game.id}")
    seven_diamonds[0].update_attributes(:viable_play => true)
    
    #set initial turn to player with the 7 of diamonds
    first_to_play = seven_diamonds[0].lineup.seat_number
    @game.update_attributes(:turn => first_to_play)
  end
end