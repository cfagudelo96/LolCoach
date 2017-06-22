class CreateSummonerSpells < ActiveRecord::Migration[5.1]
  def change
    create_table :summoner_spells do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
