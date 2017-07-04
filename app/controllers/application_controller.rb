class ApplicationController < ActionController::API
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
