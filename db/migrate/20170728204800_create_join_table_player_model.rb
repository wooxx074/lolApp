class CreateJoinTablePlayerModel < ActiveRecord::Migration[5.0]
  def change
    create_join_table :players, :matches do |t|
      t.index [:player_id, :match_id]
    end
  end
end
