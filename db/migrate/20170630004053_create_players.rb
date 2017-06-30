class CreatePlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :leagues do |t|
      t.integer :league_id
      t.string :name
      t.string :
      t.timestamps
    end
  end

  def change
    create_table :teams do |t|
      t.integer :team_id
      t.belongs_to :league, index: true, foreign_key: true
      t.string :name
      t.string :
      t.timestamps
    end
  end

  def change
    create_table :players do |t|
      t.integer :player_id
      t.belongs_to :team, index: true, foreign_key: true
      t.timestamps
    end
  end
end
