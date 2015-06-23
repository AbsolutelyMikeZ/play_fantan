class DealNewGame
  def initialize(game)
    @game = game
  end
  
  def deal
    deck = Card.all.shuffle
    
    lineups = @game.lineups.to_a
    deck.each do |d|
      lineups[0].hands.create!(:card_id => d.id)
      lineups.push lineups.shift
    end
    
    #find hand where game = game and card = 7 diamonds and set it's viable_play to true
    seven_diamonds = Hand.joins(:card).joins(:lineup).where("cards.abbreviation = '7d'").where("lineups.game_id = #{@game.id}").first
    seven_diamonds.update_attributes(:viable_play => true)
    
    #set initial turn to player with the 7 of diamonds
    @game.update_attributes(:turn => seven_diamonds.lineup.seat_number)
    
    # If player with 7d is a bot, get the game started
    seven_diamonds.lineup.player.human? || PlayBotTurn.new(@game.id).play_turn
  end
  
end