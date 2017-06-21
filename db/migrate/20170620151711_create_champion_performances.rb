class CreateChampionPerformances < ActiveRecord::Migration[5.1]
  def change
    create_table :champion_performances do |t|
      t.integer :champion_id
      t.string :role
      t.decimal :win_rate
      t.decimal :ban_rate

      t.timestamps
    end
  end
end
