require 'test_helper'

class FixtureLoadingTest < ActionDispatch::IntegrationTest

  def setup
    @lineup = Lineup.first
  end

  test "ensure proper number of hands" do
    assert_equal 10, @lineup.hands.count
  end

end
