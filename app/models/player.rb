class Player < ActiveRecord::Base
  
  has_many :lineups
  has_many :games, :through => :lineups
  
end
