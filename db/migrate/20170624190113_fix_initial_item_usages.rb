class FixInitialItemUsages < ActiveRecord::Migration[5.1]
  def change
    rename_column :initial_item_usages, :champion_id, :champion_performance_id
    add_column :initial_item_usages, :quantity, :integer
  end
end
