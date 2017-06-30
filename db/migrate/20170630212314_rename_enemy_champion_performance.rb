class RenameEnemyChampionPerformance < ActiveRecord::Migration[5.1]
  def change
    rename_column :matchups, :enemy_champion_performance_id, :enemy_champion_id
  end
end
