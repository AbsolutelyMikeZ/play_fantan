class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :suit
      t.string :name
      t.string :abbreviation
      t.integer :rank

      t.timestamps null: false
    end
  end
end
