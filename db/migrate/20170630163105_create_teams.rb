class CreateTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :teams do |t|
      t.integer :team_id
      t.belongs_to :league, index: true, foreign_key: true
      t.string :name
      t.timestamps
    end
  end
end
