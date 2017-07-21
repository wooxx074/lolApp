class ChangeMatchIntLimit < ActiveRecord::Migration[5.0]
  def change
    change_column :matches, :game_id, :integer, limit: 8
  end
end
