class CoachesController < ApplicationController
  include Speech

  before_action :set_role,
                only: %i[champion_items
                         champion_initial_items
                         champion_final_items
                         champions_to_ban
                         counters_to_champion]
  before_action :set_champion_name,
                :set_champion,
                :set_champion_performance,
                only: %i[champion_items
                         champion_initial_items
                         champion_final_items
                         counters_to_champion]

  def help
    action = params[:result][:action]
    parameters = params[:result][:parameters]
    if action == 'champions_to_ban'
      redirect_to action: 'champions_to_ban', role: parameters[:role]
    elsif action == 'champion_items'
      redirect_to action: 'champion_items',
                  champion_name: parameters[:champion],
                  role: parameters[:role]
    elsif action == 'champion_initial_items'
      redirect_to action: 'champion_initial_items',
                  champion_name: parameters[:champion],
                  role: parameters[:role]
    elsif action == 'champion_final_items'
      redirect_to action: 'champion_final_items',
                  champion_name: parameters[:champion],
                  role: parameters[:role]
    elsif action == 'counters_to_champion'
      redirect_to action: 'counters_to_champion',
                  champion_name: parameters[:champion],
                  role: parameters[:role]
    elsif action == 'update_champions'
      Champion.update_champions
    elsif action == 'update_items'
      Item.update_items
    elsif action == 'update_summoners'
      SummonerSpell.update_summoner_spells
    elsif action == 'update_runes'
      Rune.update_runes
    end
  end

  def counters_to_champion
    counters = @champion_performance.counters
    speech = "The top counters for #{@champion_performance} are #{list_to_text(counters, 'and')}"
    render json: { speech: speech, displayText: speech }
  end

  def champion_items
    initial_items_text = list_to_text(@champion_performance.initial_item_usages, 'and')
    final_items_text = list_to_text(@champion_performance.final_item_usages, 'and')
    speech = "For your initial items I would recommend #{initial_items_text}. Then for your final build I think you should go for #{final_items_text}"
    render json: { speech: speech, displayText: speech }
  end

  def champion_initial_items
    initial_items_text = list_to_text(@champion_performance.initial_item_usages, 'and')
    text = "I recommend you buy for your first items #{initial_items_text}"
    render json: { speech: text, displayText: text }
  end

  def champion_final_items
    final_items_text = list_to_text(@champion_performance.final_item_usages, 'and')
    text = "Your final build should have #{final_items_text}"
    render json: { speech: text, displayText: text }
  end

  def champions_to_ban
    highest_win_rate_champions = Champion.highest_win_rate_champions(@role)
    text = "You should ban #{list_to_text(highest_win_rate_champions, 'or')}"
    response = { speech: text, displayText: text }
    render json: response
  end

  private

  def set_champion_name
    @champion_name = params[:champion_name]
  end

  def set_role
    @role = params[:role]
  end

  def set_champion
    @champion = Champion.find_by_name(@champion_name)
    render json: Champion.champion_not_found_response(@champion_name) if @champion.blank?
  end

  def set_champion_performance
    @champion_performance = @champion.champion_performance(@role)
    render json: @champion.role_not_specified_response if @champion_performance.blank?
  end
end
