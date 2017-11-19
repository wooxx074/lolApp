module MatchMethods
  def json_parse(source)
    encoded_url = URI.encode(source)
    resp = Net::HTTP.get_response(URI.parse(encoded_url))
    data = resp.body
    result = JSON.parse(data)
    return result
  end   
  
  def region_check(region)
    case
    when region == "LCK"
      return "kr"
    when region == "NA LCS"
      return "na1"
    when region == "EU LCS"
      return "euw1"
    else
      return "No Region Found"
    end
  end 
  
  def current_game_version
    game_versions = json_parse("https://na1.api.riotgames.com/lol/static-data/v3/versions?api_key=#{ENV['riot_key']}")
    current_game_version = game_versions[0] #Find most current version of game for updated API
    return "7.15.1" #current_game_version - For some reason Riot current has rate limits on static api calls should return current_game_version
  end
end