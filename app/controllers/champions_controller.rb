class ChampionsController < ApplicationController
  include Speech

  before_action :set_champion_name, :set_champion

  def champion_tip
    tip = @champion.tips.where(against: false).order('RANDOM()').first
    text = tip.present? ? tip.to_s : "I didn't find any advise to give you, sorry about that"
    response = { speech: text, displayText: text }
    render json: response
  end

  def against_champion_tip
    tip = @champion.tips.where(against: true).order('RANDOM()').first.to_s
    text = tip.present? ? tip.to_s : "I didn't find any advise to give you, sorry about that"
    response = { speech: text, displayText: text }
    render json: response
  end
end
