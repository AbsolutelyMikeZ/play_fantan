class CreateLineups < ActiveRecord::Migration
  def change
    create_table :lineups do |t|
      t.belongs_to :game, index: true
      t.belongs_to :player, index: true
      t.integer :seat_number
      t.integer :amount_paid, default: 0
      t.boolean :won_pot, default: false

      t.timestamps null: false
    end
  end
end
