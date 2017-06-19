class CreateChampions < ActiveRecord::Migration[5.1]
  def change
    create_table :champions do |t|
      t.integer :champion_id
      t.string :name
      t.string :key
      t.string :title

      t.timestamps
    end
  end
end
