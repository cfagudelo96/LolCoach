class RemoveChampionIdFromChampions < ActiveRecord::Migration[5.1]
  def change
    remove_column :champions, :champion_id
  end
end
