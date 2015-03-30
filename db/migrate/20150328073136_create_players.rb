class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password
      t.string :screen_name
      t.boolean :human

      t.timestamps null: false
    end
  end
end
