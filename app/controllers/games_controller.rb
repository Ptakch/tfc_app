class GamesController < ApplicationController
  def index
  	@games = Game.all
  end

  def new
  end

  def create
  	
  	@game = Game.new
	@game.blue_team = params['blue_team']
	@game.red_team = params['red_team']
	@game.file_name = params['file'].original_filename
	@game.game_title = params['name']
	@game.map = @map
	@game.save
  	file = params[:file].read.to_s
  	game_started = false

  	@players_involved = { :red => [], :blue => [] }

  	file.each_line do |line|
	    find_map line
	  	find_server line
	    if line.match( /Match_Begins_Now/ )&& game_started == false
	    	game_started = true
	    else
	  		break_into_pieces line
	  		
	  	end
	end

	@players_involved[:red].each do |player|
		current_player = Player.find_by :steam_id => player
		if current_player
			current_player.red_maps += 1
			current_player.save
		end
	end

	@players_involved[:blue].each do |player|
		current_player = Player.find_by :steam_id => player
		if current_player
			current_player.blue_maps += 1
			current_player.save
		end
	end
  	redirect_to games_path
  end

  def edit
  end

  def destroy
  	@game = Game.find_by( game_title: params[:game] )
  	@game.destroy

  	redirect_to games_path
  end

  def show
  	@game = Game.find(params[:id])
  	@red_team = Team.find_by(name: @game.red_team)
  	@blue_team = Team.find_by(name: @game.blue_team)
  end

  private
	  
	def find_server line
		results = line.match /Server\sname\sis\s\"(?<server-name>[^"]+)/
		if results && results.length !=0
			puts "*** #{results['server-name']}"
			return results['server-name']
		end
	end  

	def find_map line 
		results = line.match /Started map \"(?<map-name>\w+)\"/ 
		if results && results.length != 0
			puts "*** #{results['map-name']} ***"
			@game.map = results['map-name']
			@game.save
			return results['map-name'] 
		end
	end

	def find_action str
		if str.scan( /killed/ ).any?
			"kill"
		elsif str.scan( /committed suicide/ ).any?
			"suicide"
		elsif str.scan( /triggered/ ).any?
			"trigger"
		else
			nil
		end
	end

	def capture_kill line
		res = line.match( 
			/.*\"(?<username>.*)<\d+
			 .*(?<first-id>STEAM_\d+:\d+:\d+)
			 .*(?<first-team>(Red|Blue))
			 .*
			 .*(?<second-id>STEAM_\d+:\d+:\d+)
			 .*(?<second-team>(Red|Blue))
			/x )

		unless @players_involved[:red].index( res["first-id"] ) || @players_involved[:blue].index( res["first-id"] )
			if res["first-team"] == "Red"
				@players_involved[:red] << res["first-id"]
			else 
				@players_involved[:blue] << res["first-id"]
			end
		end		

		unless @players_involved[:red].index( res["second-id"] ) || @players_involved[:blue].index( res["second-id"] )
			if res["second-team"] == "Red"
				@players_involved[:red] << res["second-id"]
			else 
				@players_involved[:blue] << res["second-id"]
			end
		end

		player = Player.find_by :steam_id => res['first-id']
		if player
			player.red_tks += 1 if res["first-team"] == res["second-team"] && res["first-team"] == "Red"
			player.blue_tks += 1 if res["first-team"] == res["second-team"] && res["first-team"] == "Blue"
			player.blue_kills += 1 if res["first-team"] != res["second-team"] && res["first-team"] == "Blue"
			player.red_kills += 1 if res["first-team"] != res["second-team"] && res["first-team"] == "Red"

			player.save
		else 
			player = Player.new
			player.steam_id = res["first-id"]
			player.name = res["username"]

			player.red_tks += 1 if res["first-team"] == res["second-team"] && res["first-team"] == "Red"
			player.blue_tks += 1 if res["first-team"] == res["second-team"] && res["first-team"] == "Blue"
			player.blue_kills += 1 if res["first-team"] != res["second-team"] && res["first-team"] == "Blue"
			player.red_kills += 1 if res["first-team"] != res["second-team"] && res["first-team"] == "Red"

			player.save
		end

		player2 = Player.find_by :steam_id => res['second-id']
		if player2
			player2.red_deaths += 1 if res['second-team'] == "Red"
			player2.blue_deaths += 1 if res['second-team'] == "Blue"

			player2.save
		end
	

	end

	def capture_suicide line		
		res = line.match(
			/.*(?<suicide-id>STEAM_\d+:\d+:\d+)/
			)
		puts "#{res['suicide-id']} committed SUICIDE"
	end

	def capture_trigger line		
		res2 = line.match(
			/.*(?<trigger-id>STEAM_\d+:\d+:\d+)><\w+>"\striggered\s"(?<trigger-action>\w+\s?\w+\s?\w+)"/
			)
		
		player = Player.find_by :steam_id => res2['trigger-id'] if res2
		if res2 && player
			case res2['trigger-action']
			when "Sentry_Destroyed"
				puts "#{res2['trigger-id']} destroyed sentry : action #{res2['trigger-action']} "
				player.blue_sgs += 1
			when "Red Flag"
				puts "#{res2['trigger-id']} touched the flag : action #{res2['trigger-action']}"
				player.blue_touches += 1
			when "Team 1 dropoff"
				puts "#{res2['trigger-id']} Captured the flag : action #{res2['trigger-action']}"
				player.blue_caps += 1
			end
			player.save
		end
	end

	def break_into_pieces line
		case find_action( line )
		when "kill" then capture_kill(line)
		when "suicide" then capture_suicide(line)
		when "trigger" then capture_trigger(line)		
		end
	end
	
end




