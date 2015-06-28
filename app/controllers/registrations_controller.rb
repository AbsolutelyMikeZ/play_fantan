class RegistrationsController < Devise::RegistrationsController
  
  private
  
  def sign_up_params
    params.require(:player).permit(:first_name, :last_name, :email, :password, :screen_name)
  end
  
  def account_update_params
    params.require(:player).permit(:first_name, :last_name, :email, :password, :screen_name, :current_password)
  end
  
end