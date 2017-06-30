class AddAvatarColumnsToPlayers < ActiveRecord::Migration[5.0]
  def up
    add_attachment :players, :avatar
  end
end
