require 'test_helper'

class PasswordResetTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
    @player = players(:sid)
  end
  
  test "password reset" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    # Invalid Email
    post password_resets_path, password_reset: { email: " " }
    assert_not flash.empty?
    assert_template 'password_resets/new'
    # Valid Email
    post password_resets_path, password_reset: { email: @player.email }
    assert_not_equal @player.reset_digest, @player.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    # Password reset form
    player = assigns(:player)
    # Wrong email
    get edit_password_reset_path(player.reset_token, email: "")
    assert_redirected_to root_url
    # Right email, wrong token
    get edit_password_reset_path('wrong token', email: player.email)
    assert_redirected_to root_url
    # Right email, right token
    get edit_password_reset_path(player.reset_token, email: player.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", player.email
    # Invalid password
    patch password_reset_path(player.reset_token),
          email: player.email,
          player: { password: "short" }
    assert_template 'password_resets/edit'
    # Expired token
    @player.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path(player.reset_token),
          email: player.email,
          player: { password: "longenough" }
    assert_not flash.empty?
    assert_redirected_to new_password_reset_url
    # Valid password
    @player.update_attribute(:reset_sent_at, 1.hour.ago)
    patch password_reset_path(player.reset_token),
          email: player.email,
          player: { password: "longenough" }
    assert_not flash.empty?
    assert is_logged_in?
    assert_redirected_to player
  end
end
