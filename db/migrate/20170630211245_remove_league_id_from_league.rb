class RemoveLeagueIdFromLeague < ActiveRecord::Migration[5.0]
  def change
    remove_column :leagues, :league_id
  end
end
