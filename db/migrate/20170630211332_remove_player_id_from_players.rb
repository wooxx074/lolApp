class RemovePlayerIdFromPlayers < ActiveRecord::Migration[5.0]
  def change
    remove_column :players, :player_id
  end
end
