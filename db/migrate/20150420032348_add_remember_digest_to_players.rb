class AddRememberDigestToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :remember_digest, :string
  end
end
