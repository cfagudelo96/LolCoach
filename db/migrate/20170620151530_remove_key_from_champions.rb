class RemoveKeyFromChampions < ActiveRecord::Migration[5.1]
  def change
    remove_column :champions, :key
  end
end
