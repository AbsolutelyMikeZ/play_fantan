class PasswordResetsController < ApplicationController
  
  before_action :get_player, only: [:edit, :update]
  before_action :valid_player, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  
  def new
  end
  
  def create
    @player = Player.find_by(email: params[:password_reset][:email].downcase)
    if @player
      @player.create_reset_digest
      @player.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions."
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found."
      render 'new'
    end
  end

  def edit
  end
  
  def update
    if password_blank?
      flash.now[:danger] = "Password can't be blank"
      render 'edit'
    elsif @player.update_attributes(player_params)
      log_in @player
      flash[:success] = "Password has been reset."
      redirect_to @player
    else
      render 'edit'
    end
  end
  
  private

  def player_params
    params.require(:player).permit(:password)
  end

  def password_blank?
    params[:player][:password].blank?
  end
  
  def get_player
    @player = Player.find_by(email: params[:email])
  end
  
  def valid_player
    unless (@player && @player.authenticated?(:reset, params[:id]))
      redirect_to root_url
    end
  end
  
  def check_expiration
    if @player.password_reset_expired?
      flash[:danger] = "Password reset has expired. Please try again."
      redirect_to new_password_reset_url
    end
  end
  
end
