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
    if @player.last_regenerated_matches.nil? or @player.last_regenerated_matches < (DateTime.now - 0.5.hours)
      # Find League by player's team ID
      team = Team.find(@player.team_id).league_id
      league = League.find(team)
      region = region_check(league.name)
      @player.summonername.each do |sumname, accountId|
        # Pulls Riot API matchlist, beginning from two weeks back. Ordered by most recent first.
        source = "https://#{region}.api.riotgames.com/lol/match/v3/matchlists/by-account/#{accountId}?beginTime=#{(DateTime.now.strftime('%Q').to_i-1209600000).to_s}&api_key=#{ENV['riot_key']}"
        matchList = json_parse(source)
        matchList["matches"].each do |game|
          gameId = game["gameId"].to_s
          found_match = Match.find_by_game_id(gameId)
          if found_match.nil?
            source = "https://#{region}.api.riotgames.com/lol/match/v3/matches/#{gameId}?api_key=#{ENV['riot_key']}"
            game_info = json_parse(source)
            new_match = Match.new(match_info: game_info, game_id: gameId)
            new_match.pros_in_game << "#{accountId}"
            new_match.save
          else
            unless found_match.pros_in_game.include?("#{accountId}")
              found_match.pros_in_game << "#{accountId}"
            end
          end
        end
      end
      @player.last_regenerated_matches = DateTime.now
      @player.save
      return "Updated"
    end
  end
end