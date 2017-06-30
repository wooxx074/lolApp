class AddAvatarColumnsToLeagues < ActiveRecord::Migration[5.0]
  def up
    add_attachment :leagues, :avatar
  end
end
