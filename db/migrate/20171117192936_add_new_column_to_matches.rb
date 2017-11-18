class AddNewColumnToMatches < ActiveRecord::Migration[5.0]
  def change
    add_column :matches, :match_timeline, :text
  end
end
