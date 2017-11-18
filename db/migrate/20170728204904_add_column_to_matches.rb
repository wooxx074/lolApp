class AddColumnToMatches < ActiveRecord::Migration[5.0]
  def change
    add_column :matches, :champs_pro_played, :text, array: true, default: [].to_yaml
  end
end
