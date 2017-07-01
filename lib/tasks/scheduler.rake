desc "This task is called by the Heroku scheduler add-on"
task :update_database => :environment do
  Champion.update_champions
  Item.update_items
  SummonerSpell.update_summoner_spells
  Rune.update_runes
end