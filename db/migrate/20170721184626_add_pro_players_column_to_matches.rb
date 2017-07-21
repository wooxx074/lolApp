class AddProPlayersColumnToMatches < ActiveRecord::Migration[5.0]
  def change
    add_column :Matches, :pros_in_game, :text, array: true, default: [].to_yaml
  end
end
