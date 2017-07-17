class ChangeSummNameType < ActiveRecord::Migration[5.0]
  def change
    change_column :players, :summonername, :text
  end
end
