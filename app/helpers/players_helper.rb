module PlayersHelper
  
  def show_last_name
    current_player == @player ? @player.last_name : @player.last_name[0,1]
  end
  
  def show_email
    current_player == @player ? @player.email : "hidden"
  end
  
end
