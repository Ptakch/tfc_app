class TeamsController < ApplicationController

	def index
		@teams = Team.all
	end

	def show
		@team = Team.find(params[:id])
		@games = Game.where( "red_team = :team_name OR blue_team = :team_name", {team_name: @team.name} )
	end


end
