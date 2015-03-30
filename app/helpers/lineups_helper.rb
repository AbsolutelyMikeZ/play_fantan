module LineupsHelper
  
  def pay_pot
    self.amount_paid += 1
    self.save
  end
  
end
