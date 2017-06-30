class CreateMatchups < ActiveRecord::Migration[5.1]
  def change
    create_table :matchups do |t|
      t.integer :champion_performance_id
      t.integer :enemy_champion_performance_id
      t.decimal :win_rate
      t.decimal :enemy_win_rate
      t.integer :gold_earned
      t.integer :enemy_gold_earned

      t.timestamps
    end
  end
end
