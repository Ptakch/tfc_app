class GamesController < ApplicationController
  def index
  	@games = Game.all
  end

  def new
  end

  def create
  	file = params[:file].read.to_s
  	game_started = false
  	file.each_line do |line|
	    if line.match( /Match_Begins_Now/ ) && game_started == false
	    	game_started = true

	    else
	  		break_into_pieces line
	  		find_map line
	  		find_server line
	  	end
	 end


  	redirect_to games_path
  end

  def edit
  end

  def show
  end

  private
	  # ALL YOUR METHODS GO HERE!
	def find_server line
		results = line.match /Server\sname\sis\s\"(?<server-name>[^"]+)/
		if results && results.length !=0
			puts "*** #{results['server-name']}"
			return results['server-name']
		end
	end  

	def find_map line # finds the map.
		results = line.match /Started map \"(?<map-name>\w+)\"/ 
		if results && results.length != 0
			puts "*** #{results['map-name']} ***"
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
		# puts "Captured Kill called"
		res = line.match( 
			/.*\"(?<username>.*)<\d+
			 .*(?<first-id>STEAM_\d+:\d+:\d+)
			 .*(?<first-team>(Red|Blue))
			 .*
			 .*(?<second-id>STEAM_\d+:\d+:\d+)
			 .*(?<second-team>(Red|Blue))
			/x )

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
		# binding.pry
		# # puts "#{res['first-id']} KILLED HIMSELF" if res["first-id"] == res["second-id"]
		# puts "#{res['first-id']} got a TEAM KILL" if res["first-team"] == res["second-team"]
		# player. if res["first-team"] != res["second-team"]

	end

	def capture_suicide line
		# puts "Capture Suicide called"
		res = line.match(
			/.*(?<suicide-id>STEAM_\d+:\d+:\d+)/
			)
		puts "#{res['suicide-id']} committed SUICIDE"
	end

	def capture_trigger line
		# puts "Capture trigger called"

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


# @game = Game.new
# @game.file_name = ......
# @game.game_date = ......
# @game.map = ......
# @game.save
