require 'test_helper'

class PlayerMailerTest < ActionMailer::TestCase
  test "password_reset" do
    player = players(:sid)
    player.reset_token = Player.new_token
    mail = PlayerMailer.password_reset(player)
    assert_equal "Password Reset", mail.subject
    assert_equal [player.email], mail.to
    assert_equal ["FanTan@fantan.herokuapp.com"], mail.from
    assert_match player.reset_token, mail.body.encoded
    assert_match CGI::escape(player.email), mail.body.encoded
  end

end
