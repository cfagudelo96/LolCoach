class CoachesController < ApplicationController

  def help
    action = params[:result][:action]
    if action == 'champions_to_ban'
      champions_to_ban
    elsif action == 'update_champions'
      Champion.update_champions
    elsif action == 'update_items'
      Item.update_items
    elsif action == 'populate_database'
      Champion.all.each do |champion|
        ChampionPerformance::ROLES.each do |role|
          ChampionPerformance.create(champion_id: champion.id, role: role)
        end
      end
    end
  end

  private

  def champions_to_ban
    role = params[:result][:parameters][:role]
    highest_win_rate_champions = Champion.highest_win_rate_champions(role)
    text = 'You should ban '
    text += list_to_text(highest_win_rate_champions)
    response = { speech: text, displayText: text }
    render json: response
  end

  def list_to_text(list)
    text = ''
    list.each_with_index do |element, index|
      if index + 1 == list.length && list.length > 1
        text += ' or '
      elsif index != 0
        text += ', '
      end
      text += element.to_s
    end
    text
  end
end
