class RemoveTeamIdFromTeam < ActiveRecord::Migration[5.0]
  def change
    remove_column :teams, :team_id
  end
end
