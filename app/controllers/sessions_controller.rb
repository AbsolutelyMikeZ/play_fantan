class SessionsController < ApplicationController

  def new
  end

  def create
    player = Player.find_by(email: params[:session][:email].downcase)
    if player && player.authenticate(params[:session][:password])
      log_in player
      params[:session][:remember_me] == '1' ? remember(player) : forget(player) 
      redirect_back_or player
    else
      flash.now[:notice] = "Incorrect email/password combination"
      render 'new'
    end
  end
  
  def destroy
    log_out if logged_in?
    redirect_to login_path
  end

end
