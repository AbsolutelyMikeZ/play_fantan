class Card < ActiveRecord::Base
  
  has_and_belongs_to_many :games
  has_many :hands
  has_many :lineups, :through => :hands
  
  scope :arranged, lambda { order("cards.id ASC") }
  
end
