class ChampionPerformancesController < ApplicationController
  include Speech

  before_action :set_champion_name, :set_role,
                :set_champion, :set_champion_performance

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
end
