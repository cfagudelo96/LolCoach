class CreateRunes < ActiveRecord::Migration[5.1]
  def change
    create_table :runes do |t|
      t.string :name
      t.string :description
      t.string :type
      t.integer :tier

      t.timestamps
    end
  end
end
