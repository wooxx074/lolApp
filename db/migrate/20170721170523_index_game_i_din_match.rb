class IndexGameIDinMatch < ActiveRecord::Migration[5.0]
  def change
    add_index :matches, :game_id, unique: true
  end
end
