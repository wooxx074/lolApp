class PlayersController < ApplicationController
  def new
    # Add new players
    @player = Player.new
  end

  def create
    # Mass assignment of form fields to create teams
    @player = Player.new(player_params)
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

  end

  def edit
    @player = Player.find( params[:id] )
  end

  def update
    # Retrieve players from database
    @player = Player.find( params[:id])
    # Mass assign edited profile attributes and update
    if @player.update_attributes(player_params)
      flash[:success] = "#{@player.name} updated!"
      redirect_to edit_player_path(id: params[:id])
    else
      render action :edit
    end
  end

  private
  def player_params
    params.require(:player).permit(:name, :summonername, :team_id, :role, :twitchtv, :avatar)
  end
end
