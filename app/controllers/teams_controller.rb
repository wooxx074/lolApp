class TeamsController < ApplicationController
  # GET to /teams/new
  def new
    @team = Team.new
  end
  # POST to /teams
  def create
    # Mass assignment of form fields to create teams
    @team = Team.new(team_params)
    # Saving team into database
    if @team.save
      name = params[:team][:name]
      league = params[:team][:league_id]
      # flash if successfully saved
      flash[:success] = "#{name} has been saved."
      redirect_to new_team_path
    else
      flash[:danger] = @team.errors.full_messages.join(", ").html_safe
      redirect_to new_team_path
    end
  end

  # GET to /teams/:id/edit
  def edit
    @team = Team.find(params[:id])
  end

  # PUT to /teams/:id
  def update
    # Retrieve team from database
    @team = Team.find( params[:id])
    # Mass assign edited profile attributes and update
    if @team.update_attributes(team_params)
      flash[:success] = "#{@team.name} updated!"
      redirect_to edit_team_path(id: params[:id])
    else
      render action :edit
    end
  end

  private
  def team_params
    params.require(:team).permit(:name, :league_id, :avatar)
  end
end
