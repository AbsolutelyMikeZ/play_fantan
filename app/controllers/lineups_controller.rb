class LineupsController < ApplicationController
  
  def pay_pot
    @lineup = Lineup.find(params[:id])
    @lineup.amount_paid += 1
    @lineup.save
    redirect_to controller: 'games', action: 'advance_turn', id: @lineup.game_id
  end
end
