class CreatePlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :leagues do |t|
      t.integer :league_id
      t.string :name
      add_attachment :users, :avatar
      t.timestamps
    end
  end

  def change
    create_table :teams do |t|
      t.integer :team_id
      t.belongs_to :league, index: true, foreign_key: true
      t.string :name
      add_attachment :users, :avatar
      t.timestamps
    end
  end

  def change
    create_table :players do |t|
      t.integer :player_id
      t.string :summonername
      t.string :role
      t.string :twitchtv
      
      t.belongs_to :team, index: true, foreign_key: true
      add_attachment :users, :avatar
      t.timestamps
    end
  end
  
  def change
    create_table :matches do |t|
      t.integer :match_id
      t.text 'match_info'
      t.timestamps
    end
  end
end
