class RemoveCustomAuthenticationFromPlayers < ActiveRecord::Migration
  def change
    change_table :players do |t|
      t.remove :password_digest, :remember_digest, :reset_digest, :reset_sent_at
    end
  end
end
