class Lineup < ActiveRecord::Base
  
  belongs_to :player
  belongs_to :game
  has_many :hands, dependent: :destroy
  has_many :cards, :through => :hands
  
  scope :seated, -> { order(:seat_number) }
end
