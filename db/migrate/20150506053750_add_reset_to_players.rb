class AddResetToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :reset_digest, :string
    add_column :players, :reset_sent_at, :datetime
  end
end
