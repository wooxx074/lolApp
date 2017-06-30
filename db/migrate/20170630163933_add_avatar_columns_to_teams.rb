class AddAvatarColumnsToTeams < ActiveRecord::Migration[5.0]
  def up
    add_attachment :teams, :avatar
  end
end
