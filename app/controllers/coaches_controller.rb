class CoachesController < ApplicationController

  def help
    action = params[:result][:action]
    if action == 'test'
      test(params[:result][:parameters][:champion])
    end
  end

  private

  def test(champion)
    champion = Champion.find_by_name(champion)
    render json: champion
  end
end
