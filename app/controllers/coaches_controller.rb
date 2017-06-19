class CoachesController < ApplicationController

  def help
    action = params[:result][:action]
    if action == 'test'
      test(params[:result][:parameters][:champion])
    elsif action == 'update_champions'
      render json: Champion.update_champions
    end
  end

  private

  def test(champion)
    champion = Champion.find_by_name(champion)
    text = "#{champion.name} is #{champion.title}"
    response = { speech: text, displayText: text }
    render json: response
  end
end
