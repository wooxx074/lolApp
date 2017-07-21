class AddLastRegeneratedToMatches < ActiveRecord::Migration[5.0]
  def change
    add_column :players, :last_regenerated_matches, :datetime
  end
end
