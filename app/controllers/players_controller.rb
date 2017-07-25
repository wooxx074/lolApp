class PlayersController < ApplicationController
  include PlayerHelper
  
  def set_player_params
    @params = params[:player]
  end
  
  def new
    # Add new players
    @player = Player.new
  end

  def create
    # Mass assignment of form fields to create teams
    @player = Player.new(player_params.except(:summonername))
      summonerlist = params[:player][:summonername].split(", ")
      teamId = params[:player][:team_id]
      leagueId = Team.find(teamId).league_id
      league = League.find(leagueId)
      summonerlist.each do |smname|
        @player.summonername[smname] = retrieve_sumn_id(region_check(league.name), smname)
      end

    # Saving team into database
    if @player.save
      name = params[:player][:name]
      # flash if successfully saved
      flash[:success] = "#{name} has been saved."
      redirect_to new_player_path
    else
      flash[:danger] = @player.errors.full_messages.join(", ").html_safe
      redirect_to new_player_path
    end
  end

  def show
    @player = Player.find( params[:id] )
    match_list = []
    match_short_list = []
    @match_hash = Hash.new
    @player.summonername.each do |sumname, accountId|
      match_list = Match.select{|game| game.pros_in_game.include? accountId.to_s}
      match_short_list << match_list.take(5)
      match_short_list = match_short_list.uniq #removes any duplicate entries in short list array
      match_short_list.each do |match|
      match_hash[accountId] = match
      end
      @sorted_matches = match_hash.sort_by {|id, match| match[0]["game_id"].to_i }.reverse!
    end
     
    
  end

  def edit
    @player = Player.find( params[:id] )
  end

  def update
    # Retrieve players from database
    @player = Player.find( params[:id])
    updatedParams = player_params.clone
    summonerlist = params[:player][:summonername].split(", ")
      teamId = params[:player][:team_id]
      leagueId = Team.find(teamId).league_id
      league = League.find(leagueId)
      summonerHash = Hash.new
      summonerlist.each do |smname|
        summonerHash[smname] = retrieve_sumn_id(region_check(league.name), smname)
      end
    updatedParams[:summonername] = summonerHash
    
    # Mass assign edited profile attributes and update
    if @player.update_attributes(updatedParams)
      
      flash[:success] = "#{@player.name} updated!"
      redirect_to edit_player_path(id: params[:id])
    else
      render action :edit
    end
  end

  private
  def player_params
    params.require(:player).permit(:name,:summonername, :team_id, :role, :twitchtv, :avatar)
  end
end
