Rails.application.routes.draw do
  post '/coaches/help', to: 'coaches#help'
  get '/coaches/champion_items', to: 'coaches#champion_items'
  get '/coaches/champion_initial_items', to: 'coaches#champion_initial_items'
  get '/coaches/champion_final_items', to: 'coaches#champion_final_items'
  get '/coaches/champions_to_ban', to: 'coaches#champions_to_ban'
  get '/coaches/counters_to_champion', to: 'coaches#counters_to_champion'
end
