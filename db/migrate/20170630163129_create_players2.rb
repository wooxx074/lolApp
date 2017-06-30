class CreatePlayers2 < ActiveRecord::Migration[5.0]
  def change
    create_table :players do |t|
      t.integer :player_id
      t.string :summonername
      t.string :role
      t.string :twitchtv
      
      t.belongs_to :team, index: true, foreign_key: true
      t.timestamps

    end
  end
end
