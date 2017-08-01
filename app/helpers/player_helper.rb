module PlayerHelper
  def json_parse(source)
    encoded_url = URI.encode(source)
    resp = Net::HTTP.get_response(URI.parse(encoded_url))
    data = resp.body
    result = JSON.parse(data)
    return result
  end
  
  def region_check(region)
    if region == "LCK" then return "kr"
      elsif region == "NA LCS" then return "na1"
      elsif region == "EU LCS" then return "euw1"
    else return "none"
    end
  end 

  def retrieve_sumn_id(region, sumname)
    source = "https://#{region}.api.riotgames.com/lol/summoner/v3/summoners/by-name/#{sumname}?api_key=#{ENV['riot_key']}"
    result = json_parse(source)["accountId"]
    # Show error code instead of nil for account id
    if result.nil?
      result = 111 #temp error code
    end
    
    return result
  end
  
  def save_player_matches
    # If it has been 30 minutes since the last regeneration, proceed
    if @player.last_regenerated_matches.nil? or @player.last_regenerated_matches < (DateTime.now - 0.5.hours)
      #determine DateTime endpoint as last_regenerated_matches (minus 1 hour as cushion). 
      #Endpoint will be 2 weeks back if last_regenerated_matches is nil or past 2 weeks
      dateTime_endpoint = DateTime
      if @player.last_regenerated_matches.nil? || @player.last_regenerated_matches.to_f*1000 < (DateTime.now.to_f*1000).to_i-1209600000
        dateTime_endpoint = (DateTime.now.to_f*1000).to_i-1209600000
      else
        dateTime_endpoint = (@player.last_regenerated_matches.to_f*1000).to_i-3600000
      end
      # Find League by player's team ID
      league = League.find(@player.team.league_id)
      region = region_check(league.name) #Convert region to fit Riot API url
      # Will pull match history for each summonername listed in Player
      @player.summonername.each do |sumname, accountId|
        # Pulls Riot API matchlist, beginning from two weeks back. Ordered by most recent first.
        source = "https://#{region}.api.riotgames.com/lol/match/v3/matchlists/by-account/#{accountId}?beginTime=#{dateTime_endpoint}&api_key=#{ENV['riot_key']}"
        matchList = json_parse(source)
        # If no matchList created (API error typically), will not proceed
        unless matchList["matches"].nil?
          matchList["matches"].each do |game|
            gameId = game["gameId"].to_s
            champPlayed = game["champion"]
            found_match = Match.find_by_game_id(gameId) #See if match was already put in database
            if found_match.nil? #If not, add match info to Match model
              source = "https://#{region}.api.riotgames.com/lol/match/v3/matches/#{gameId}?api_key=#{ENV['riot_key']}"
              game_info = json_parse(source)
              if game_info["status"].nil?
                new_match = Match.new(match_info: game_info, game_id: gameId)
                new_match.pros_in_game << "#{accountId}" #Adds current pro in the pool of pros participated in match
                new_match.champs_pro_played << champPlayed
                new_match.save
                @player.matches << new_match
                
              end
            else
              # If match was already in database (likely regenerated from other pro), 
              # add current pro in the pool of pros participated in match
              unless found_match.pros_in_game.include?("#{accountId}")
                found_match.pros_in_game << "#{accountId}"
                found_match.champs_pro_played << champPlayed
                @player.matches << found_match
              end
            end
          end
          @player.last_regenerated_matches = DateTime.now #Update the time in which this was last regenerated
          @player.save
          return "Updated" #Filler text to show method has been used
        else
          return "" #Return nothing if no match list has been generated
        end
      end
      
    end
  end
  
  def find_player_participation_id(current_game, current_account_id)
    if current_game.pros_in_game.include? current_account_id.to_s  
      current_game["match_info"]["participantIdentities"].each do |participant| #Cycle through participants to find matching ID
        if participant["player"]["accountId"] == current_account_id
          participantId = participant["participantId"]  #If match, save for future reference
          return participantId #Break method and return value as soon as ID is found
        else  
          next 
        end 
      end 
    end 
  end
  
  
end