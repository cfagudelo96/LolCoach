class CoachesController < ApplicationController

  def help
    action = params[:result][:action]
    if action == 'champions_to_ban'
      champions_to_ban
    elsif action == 'update_champions'
      render json: Champion.update_champions
    elsif action == 'champion_performance'
      Champion.update_champions
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
    puts "Lista de campeones con mayor winrate #{highest_win_rate_champions}"
    puts "Length de lista de campeones con mayor winrate #{highest_win_rate_champions.length}"
    text = 'You should ban '
    text += list_to_text(highest_win_rate_champions)
    response = { speech: text, displayText: text }
    render json: response
  end

  def list_to_text(list)
    puts "LLAMADA AL METODO LIST_TO_TEXT"
    text = ''
    list.each_with_index do |element, index|
      if index + 1 == list.length && list.length > 1
        text += ' or '
      elsif index != 0
        text += ', '
      end
      puts "Elemento #{element}"
      puts "TEXTO #{text}"
      text += element.to_s
    end
    text
  end

  def test(champion)
    champion = Champion.find_by_name(champion)
    text = "#{champion.name} is #{champion.title}"
    response = { speech: text, displayText: text }
    render json: response
  end
end
