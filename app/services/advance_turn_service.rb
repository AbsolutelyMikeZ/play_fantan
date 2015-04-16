class AdvanceTurnService
  def initialize (game_id)
    @game_id = game_id
  end
  
  def advance_turn
    @game = Game.includes(:players, :lineups).find(@game_id)
    @game.turn < @game.num_players ? @game.turn += 1 : @game.turn = 1
    @game.save
    
    new_lineup = @game.lineups.select { |x| x.seat_number == @game.turn }
    if new_lineup[0].player.human
      return true
    else
      play_bot_turn = PlayBotTurn.new(@game_id).play_turn
    end
  end
  
end