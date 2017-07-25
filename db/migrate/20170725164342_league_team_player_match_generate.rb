class LeagueTeamPlayerMatchGenerate < ActiveRecord::Migration[5.0]
  def change
    create_table :leagues do |t|
      t.string :name
      add_attachment :leagues, :avatar
      t.string :slug, unique: true
      t.timestamps
    end
  end

  def change
    create_table :teams do |t|
      t.belongs_to :league, index: true, foreign_key: true
      t.string :name
      add_attachment :teams, :avatar
      t.string :slug, unique: true
      t.timestamps
    end
  end

  def change
    create_table :players do |t|
      t.string :name
      t.text :summonername
      t.string :role
      t.string :twitchtv
      t.string :twitter
      t.datetime :last_regenerated_matches
      t.string :slug, unique: true
      
      t.belongs_to :team, index: true, foreign_key: true
      add_attachment :players, :avatar
      t.timestamps
    end
  end
  
  def change
    create_table :matches do |t|
      t.integer :game_id, limit: 8, unique: true
      t.text :match_info
      t.text :pros_in_game, :text, array: true, default: [].to_yaml
      t.string :slug, unique: true
      t.timestamps
    end
  end
end
