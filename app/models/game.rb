class Game < ActiveRecord::Base
  
  has_and_belongs_to_many :cards
  has_many :lineups, dependent: :destroy
  has_many :players, :through => :lineups
  
end
