class CoachesController < ApplicationController
  include Speech

  before_action :set_role, only: %i[champions_to_ban role_tip]

  def help
    action = params[:result][:action]
    parameters = params[:result][:parameters]
    redirect_to_coaches(action, parameters)
    redirect_to_champions(action, parameters)
    redirect_to_champion_performances(action, parameters)
    redirect_to_updates(action)
  end

  def redirect_to_coaches(action, parameters)
    if action == 'general_tip'
      redirect_to action: 'general_tip'
    elsif action == 'role_tip'
      redirect_to action: 'role_tip', role: parameters[:role]
    elsif action == 'champions_to_ban'
      redirect_to action: 'champions_to_ban', role: parameters[:role]
    end
  end

  def redirect_to_champions(action, parameters)
    if action == 'champion_tip'
      redirect_to controller: 'champions', action: 'champion_tip',
                  champion_name: parameters[:champion]
    elsif action == 'against_champion_tip'
      redirect_to controller: 'champions', action: 'against_champion_tip',
                  champion_name: parameters[:champion]
    end
  end

  def redirect_to_champion_performances(action, parameters)
    if action == 'champion_items'
      redirect_to controller: 'champion_performances', action: 'champion_items',
                  champion_name: parameters[:champion], role: parameters[:role]
    elsif action == 'champion_initial_items'
      redirect_to controller: 'champion_performances', action: 'champion_initial_items',
                  champion_name: parameters[:champion], role: parameters[:role]
    elsif action == 'champion_final_items'
      redirect_to controller: 'champion_performances', action: 'champion_final_items',
                  champion_name: parameters[:champion], role: parameters[:role]
    elsif action == 'counters_to_champion'
      redirect_to controller: 'champion_performances', action: 'counters_to_champion',
                  champion_name: parameters[:champion], role: parameters[:role]
    end
  end

  def redirect_to_updates(action)
    if action == 'update_champions'
      Champion.update_champions
    elsif action == 'update_items'
      Item.update_items
    elsif action == 'update_summoners'
      SummonerSpell.update_summoner_spells
    elsif action == 'update_runes'
      Rune.update_runes
    end
  end

  def general_tip
    text = Tip.ramdom_general_tip
    response = { speech: text, displayText: text }
    render json: response
  end

  def role_tip
    text = Tip.ramdom_rol_tip
    response = { speech: text, displayText: text }
    render json: response
  end

  def champions_to_ban
    highest_win_rate_champions = Champion.highest_win_rate_champions(@role)
    text = "You should ban #{list_to_text(highest_win_rate_champions, 'or')}"
    response = { speech: text, displayText: text }
    render json: response
  end
end
