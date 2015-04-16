class Hand < ActiveRecord::Base
  
  belongs_to :lineup
  belongs_to :card
  
  scope :arranged, lambda { order("hands.card_id ASC") }
  
end
