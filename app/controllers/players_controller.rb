class PlayersController < ApplicationController
  #included playerhelper, as putting methods in helper is more organized for this case in my opinion
  include PlayerHelper

  def new
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
    #friendly find uses name as slug for url. .downcase because slugs are all lowercase
    @player = Player.friendly.find( params[:id].downcase ) 
    match_list = @player.matches #find all matches of player through association
    match_list = match_list.uniq #removes any duplicate entries in short list array
    #sort matches by game id because Riot's game ID are chronological
    #simpler sort without digging into the ["match_info"]["gamecreation"] fields
    #reverse so most recent matches come first
    @sorted_matches = match_list.sort_by {|match| match["game_id"].to_i }.reverse!
  end

  def edit
    @player = Player.friendly.find( params[:id].downcase)
  end

  def update
    # Retrieve players from database
    @player = Player.friendly.find( params[:id].downcase)
    #Summoner names in form would be an array of names, need to re-convert to hash in background
    #clone params so that summoner names can be re-created
    updatedParams = player_params.clone
    summonerlist = params[:player][:summonername].split(", ") #Split each name in form to array
    league = League.find(@player.team.league_id) #Identify league they are in for region_check helper method
    summonerHash = Hash.new #Create new hash to re-insert into params
    summonerlist.each do |smname|
      accountId = retrieve_sumn_id(region_check(league.name), smname)
      unless accountId == 111 #111 is error code for no summoner ID found (API rate limit usually)
        summonerHash[smname] = accountId
      else 
        #If error, try to find previous corresponding account ID and add to this hash
        summonerHash[smname] = @player.summonername[smname] 
        puts "Error 111, using previous account ID"
      end
    end
    #re-insert new summonerHash into cloned params, then proceed with mass assign edited fields
    updatedParams[:summonername] = summonerHash 
    
    # Mass assign edited profile attributes and update
    if @player.update_attributes(updatedParams)
      #Signal update was successful or else return to edit page
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
