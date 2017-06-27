class FixFinalItemUsages < ActiveRecord::Migration[5.1]
  def change
    rename_column :final_item_usages, :champion_id, :champion_performance_id
    add_column :final_item_usages, :quantity, :integer
  end
end
