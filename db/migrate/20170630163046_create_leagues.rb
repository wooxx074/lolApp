class CreateLeagues < ActiveRecord::Migration[5.0]
  def change
    create_table :leagues do |t|
      t.integer :league_id
      t.string :name
      t.timestamps

    end
  end
end
