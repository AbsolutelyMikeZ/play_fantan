require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  
  def setup
    players(:good1).password = "asd23423"  #hack to make this player valid since password is validated but not a database field
    players(:good2).password = "akljfwo"
    @stringtoolong = "a" * 260
  end

  test "should be valid" do
    assert players(:good1).valid?
    assert players(:good2).valid?
  end
  
  test "first name should be valid" do
    players(:good1).first_name = " "
    assert_not players(:good1).valid?
    players(:good2).first_name = @stringtoolong
    assert_not players(:good2).valid?
  end

  test "last name should be valid" do
    players(:good1).last_name = " "
    assert_not players(:good1).valid?
    players(:good2).last_name = "askldf;jl;kajsdfalksdjfl;kasjf;lkasjlfkjsadlkfjasldkfjaslkd"
    assert_not players(:good2).valid?
  end
  
  test "email should be valid length and unique" do
    players(:good1).email = " "
    assert_not players(:good1).valid?
    players(:good2).email = @stringtoolong
    assert_not players(:good2).valid?
    players(:good2).email = "sidthekid@penguins.com"  #match :good1's email
    assert_not players(:good2).valid?
  end
  
  test "screen name should be valid length and unique" do
    players(:good1).screen_name = "  "
    assert_not players(:good1).valid?
    players(:good2).screen_name = @stringtoolong
    assert_not players(:good2).valid?
    players(:good2).screen_name = "sidthekid"  #match :good1's screenname
    assert_not players(:good2).valid?
  end
  
  test "password should be valid length" do
    players(:good1).password = "12345"
    assert_not players(:good1).valid?
  end
  
  
end
