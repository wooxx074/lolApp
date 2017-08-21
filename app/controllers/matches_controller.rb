class MatchesController < ApplicationController
  def show
    match_id = params[:match_id].to_i
    @current_match = Match.where(:game_id => match_id)
  end

end
