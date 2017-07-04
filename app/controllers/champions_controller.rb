class ChampionsController < ApplicationController
  include Speech

  before_action :set_champion_name, :set_champion

  def champion_tip
    tip = Tip
  end

  def against_champion_tip

  end
end
