class Player < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  has_many :lineups
  has_many :games, :through => :lineups
  
  before_save { email.downcase! }
  
  validates :first_name, presence: true, length: { maximum: 31 }
  validates :last_name, presence: true, length: { maximum: 31 }
  validates :email, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false }
  validates :screen_name, presence: true, length: { maximum: 31 }, uniqueness: { case_sensitive: false }
   
end
