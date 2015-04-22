class Player < ActiveRecord::Base
  
  attr_accessor :remember_token
  
  has_many :lineups
  has_many :games, :through => :lineups
  
  before_save {self.email = email.downcase }
  
  validates :first_name, presence: true, length: { maximum: 31 }
  validates :last_name, presence: true, length: { maximum: 31 }
  validates :email, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false }
  validates :screen_name, presence: true, length: { maximum: 31 }, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
  
  has_secure_password
  
  def Player.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  def Player.new_token
    SecureRandom.urlsafe_base64
  end
  
  def remember
    self.remember_token = Player.new_token
    update_attribute(:remember_digest, Player.digest(remember_token))
  end
  
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
end
