class DefaultQuantityToItemUsages < ActiveRecord::Migration[5.1]
  def change
    change_column_default :final_item_usages, :quantity, 1
    change_column_default :initial_item_usages, :quantity, 1
  end
end
