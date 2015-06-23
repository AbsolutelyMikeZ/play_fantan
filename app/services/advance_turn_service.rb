class AdvanceTurnService
  def initialize (game_id)
    @game_id = game_id
  end
  
  def advance_turn
    @game = Game.includes(:players, :lineups).find(@game_id)
    @game.turn = @game.turn < @game.num_players ? @game.turn += 1 : 1
    @game.save
    
    new_lineup = @game.lineups.where(seat_number: @game.turn).first
    new_lineup.player.human? || PlayBotTurn.new(@game_id).play_turn
  end
  
end