class LeaguesController < ApplicationController
  def new
    @league = League.new
  end

  def create
    # Mass assignment of form fields to create teams
    @league = League.new(league_params)
    # Saving team into database
    if @league.save
      name = params[:league][:name]
      # flash if successfully saved
      flash[:success] = "#{name} has been saved."
      redirect_to new_league_path
    else
      flash[:danger] = @league.errors.full_messages.join(", ").html_safe
      redirect_to new_league_path
    end
  end

  def edit
    @league = League.find(params[:id])
  end

  def update
    # Retrieve team from database
    @league = Team.find( params[:id])
    # Mass assign edited profile attributes and update
    if @league.update_attributes(team_params)
      flash[:success] = "#{@league.name} updated!"
      redirect_to edit_league_path(id: params[:id])
    else
      render action :edit
    end
  end

  private
  def league_params
    params.require(:league).permit(:name, :avatar)
  end
end
