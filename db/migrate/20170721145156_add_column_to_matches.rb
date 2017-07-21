class AddColumnToMatches < ActiveRecord::Migration[5.0]
  def change
    add_column :matches, :game_id, :integer
  end
end
