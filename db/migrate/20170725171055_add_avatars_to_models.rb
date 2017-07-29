class AddAvatarsToModels < ActiveRecord::Migration[5.0]
  def up
    add_attachment :leagues, :avatar
    add_attachment :teams, :avatar
    add_attachment :players, :avatar
  end
end
