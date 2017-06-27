class CoachesController < ApplicationController
  def help
    action = params[:result][:action]
    if action == 'champions_to_ban'
      champions_to_ban
    elsif action == 'champion_items'
      champion_items
    elsif action == 'champion_initial_items'
      champion_initial_items
    elsif action == 'champion_final_items'
      champion_final_items
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

  private

  def champion_items
    champion = Champion.find_by_name(params[:result][:parameters][:champion])
    return render json: champion_not_found_response if champion.blank?

  end

  def champion_initial_items
    champion = Champion.find_by_name(params[:result][:parameters][:champion])
    return render json: champion_not_found_response if champion.blank?
    champion.current_initial_items
    a = 0
  end

  def champion_final_items
    champion = Champion.find_by_name(params[:result][:parameters][:champion])
    return render json: champion_not_found_response if champion.blank?
    champion.current_final_items
    a = 0
  end

  def champion_not_found_response
    speech = "I couldn't find the champion that you were referring to"
    champion_name = params[:result][:parameters][:champion]
    champions_like = Champion.by_name_like(champion_name)
    display_text = if champions_like.empty? || champion_name.blank?
                     "I couldn't find the champion that you were referring to"
                   else
                     "Maybe you were referring to #{list_to_text(champions_like)}"
                   end
    { speech: speech, displayText: display_text }
  end

  def champions_to_ban
    role = params[:result][:parameters][:role]
    highest_win_rate_champions = Champion.highest_win_rate_champions(role)
    text = 'You should ban '
    text += list_to_text(highest_win_rate_champions)
    response = { speech: text, displayText: text }
    render json: response
  end

  def verify_champion(champion)
    if champion.blank?
      throw ActiveRecord::RecordNotFound
    end
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
