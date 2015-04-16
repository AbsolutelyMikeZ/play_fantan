class CreateHands < ActiveRecord::Migration
  def change
    create_table :hands do |t|
      t.belongs_to :lineup, index: true
      t.belongs_to :card, index: true
      t.boolean :viable_play, default: false
      t.integer :ai_rank

      t.timestamps null: false
    end
  end
end
