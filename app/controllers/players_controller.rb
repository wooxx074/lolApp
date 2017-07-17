class PlayersController < ApplicationController
  include PlayerHelper
  
  def set_player_params
    @params = params[:player].downcase
  end
  
  def new
    # Add new players
    @player = Player.new
  end

  def create
    # Mass assignment of form fields to create teams
    @player = Player.new(player_params.except(:summonername))
      summonerlist = params[:player][:summonername].split(", ") #splits all summoner names as their own in array
      league = League.find(@player.team.league_id)
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
    @player = Player.friendly.find( params[:id].downcase ) #friendly find uses name as slug for url
    match_list = []
    @player.summonername.each do |sumname, accountId|
      if accountId == 111
        puts "Error #{accountId} - players_controller def show"
      else
        account_matches = Match.select{|game| game.pros_in_game.include?(accountId.to_s)}
        match_list = account_matches + match_list
        match_list = match_list.uniq #removes any duplicate entries in short list array
      end
    end
    @sorted_matches = match_list.sort_by {|match| match["game_id"].to_i }.reverse!
  end

  def edit
    @player = Player.friendly.find( params[:id].downcase )
  end

  def update
    # Retrieve players from database
    @player = Player.friendly.find( params[:id].downcase)
    updatedParams = player_params.clone
    summonerlist = params[:player][:summonername].split(", ")
    league = League.find(@player.team.league_id)
    summonerHash = Hash.new
    summonerlist.each do |smname|
      accountId = retrieve_sumn_id(region_check(league.name), smname)
      unless accountId == 111
        summonerHash[smname] = accountId
      else 
        summonerHash[smname] = @player.summonername[smname]
      end
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
