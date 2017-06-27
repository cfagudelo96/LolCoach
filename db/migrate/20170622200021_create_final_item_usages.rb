class CreateFinalItemUsages < ActiveRecord::Migration[5.1]
  def change
    create_table :final_item_usages do |t|
      t.integer :champion_id
      t.integer :item_id
      t.decimal :score

      t.timestamps
    end
  end
end
