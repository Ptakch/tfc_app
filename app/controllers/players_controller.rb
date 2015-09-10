class PlayersController < ApplicationController

	def index
		@players = Player.all
		@players_ordered = Player.order( red_kills: :desc ).limit( 3 ).pluck( :name, :red_kills )
		@players_ordered2 = Player.order( red_deaths: :desc ).limit( 3 ).pluck( :name, :red_deaths )

		@players_ordered3 = Player.order( blue_sgs: :desc ).limit( 3 ).pluck( :name, :blue_sgs )
		@players_ordered4 = Player.order( blue_kills: :desc ).limit( 3 ).pluck( :name, :blue_kills )

		@players_ordered5 = Player.order( blue_deaths: :desc ).limit( 3 ).pluck( :name, :blue_deaths )
		@players_ordered6 = Player.order( blue_touches: :desc ).limit( 3 ).pluck( :name, :blue_touches )

		@players_ordered7 = Player.order( red_tks: :desc ).limit( 3 ).pluck( :name, :red_tks )
		@players_ordered8 = Player.order( blue_caps: :desc ).limit( 3 ).pluck( :name, :blue_caps )
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
