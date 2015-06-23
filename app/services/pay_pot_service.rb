class PayPotService
  def initialize(lineup_id)
    @lineup_id = lineup_id
  end
  
  def pay_the_pot
    payee = Lineup.find(@lineup_id)
    if payee.seat_number == payee.game.turn
      payee.update_attributes(:amount_paid => payee.amount_paid - 1, :last_action => "Paid")
      AdvanceTurnService.new(payee.game_id).advance_turn
    end
  end
  
end