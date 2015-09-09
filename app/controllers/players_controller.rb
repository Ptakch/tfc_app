class PlayersController < ApplicationController

	def index
		@players = Player.all
		@players_ordered = Player.pluck( :name, :red_kills ).sort_by { |item| item[1] }.reverse
		@players_ordered2 = Player.pluck( :name, :red_deaths ).sort_by { |item| item[1] }
		@players_ordered3 = Player.pluck( :name, :blue_sgs ).sort_by { |item| item[1] }.reverse
		@players_ordered4 = Player.pluck( :name, :blue_kills ).sort_by { |item| item[1] }.reverse
		@players_ordered5 = Player.pluck( :name, :blue_deaths ).sort_by { |item| item[1] }.reverse
		@players_ordered6 = Player.pluck( :name, :blue_touches ).sort_by { |item| item[1] }.reverse
		@players_ordered7 = Player.pluck( :name, :red_tks ).sort_by { |item| item[1] }.reverse
		@players_ordered8 = Player.pluck( :name, :blue_caps ).sort_by { |item| item[1] }.reverse
	end

	def show
		@player = Player.find(params[:id])
	end

	def new
		@player = Player.new
	end

	def edit
		@player = Player.find(params[:id])
	end

	def create
		@player = Player.new(player_params)

		if @player.save
			redirect_to @player
		else
			render 'new'
		end

	end

	def update
		@player = Player.find(params[:id])

		if @player.update(player_params)
			redirect_to @player
		else
			render 'edit'
		end
	end

	def destroy
		@player = Player.find(params[:id])
		@player.destroy

		redirect_to players_path
	end


	private
	def player_params
		params.require(:player).permit(:name, :steam_id, :team_id)
	end
end
