class AddLastActionToLineups < ActiveRecord::Migration
  def change
    add_column :lineups, :last_action, :string, default: 'Nothing yet'
  end
end
