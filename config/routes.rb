Rails.application.routes.draw do
  post '/coaches/help', to: 'coaches#help'
  get '/coaches/role_tip', to: 'coaches#role_tip'
  get '/coaches/general_tip', to: 'coaches#general_tip'
  get '/coaches/champions_to_ban', to: 'coaches#champions_to_ban'
  get '/champions/champion_tip', to: 'champions#champion_tip'
  get '/champions/against_champion_tip', to: 'champions#against_champion_tip'
  get '/champion_performances/counters_to_champion', to: 'champion_performances#counters_to_champion'
  get '/champion_performances/champion_items', to: 'champion_performances#champion_items'
  get '/champion_performances/champion_initial_items', to: 'champion_performances#champion_initial_items'
  get '/champion_performances/champion_final_items', to: 'champion_performances#champion_final_items'
end
