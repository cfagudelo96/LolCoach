class CreateTips < ActiveRecord::Migration[5.1]
  def change
    create_table :tips do |t|
      t.integer :champion_id
      t.integer :item_id
      t.string :role
      t.string :tip
      t.boolean :against

      t.timestamps
    end
  end
end
