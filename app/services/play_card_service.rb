class PlayCardService
  
  def initialize(hand_id, game_id)
    @hand_id = hand_id
    @game_id = game_id
  end
  
  def play_the_card
    @hand = Hand.find(@hand_id)
    @game = Game.find(@game_id)
    @lineup = @hand.lineup        # store active lineup
    
    if @hand.viable_play
      @game.cards << @hand.card  # add card to the board
      @lineup.update_attributes(:last_action => "#{@hand.card.abbreviation}")
      viable = UpdateViablePlays.new(@game_id, @hand.card.suit, @hand.card.rank).update_viable  # update viable plays
      @hand.destroy  # remove hand (remove card from the player's hand)
      
      #if no hands (cards) left, player wins the pot, else advance to next player's turn
      cards_left = Hand.where("lineup_id = #{@lineup.id}")
      if cards_left.empty?
        total_pot = Lineup.where("game_id = #{@game_id}").sum(:amount_paid)
        profit = -(total_pot - @lineup.amount_paid)
        @lineup.update_attributes(:amount_paid => profit, :won_pot => true)
        @game.update_attributes(:turn => 0, :completed => true)
      else
        advance_turn = AdvanceTurnService.new(@game_id).advance_turn
      end
      
      return true
    else
      return false
    end
  end
  
  
end