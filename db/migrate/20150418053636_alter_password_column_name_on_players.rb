class AlterPasswordColumnNameOnPlayers < ActiveRecord::Migration
  def change
    rename_column :players, :password, :password_digest
  end
end
