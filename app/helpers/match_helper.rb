module MatchHelper
  def json_parse(source)
    encoded_url = URI.encode(source)
    resp = Net::HTTP.get_response(URI.parse(encoded_url))
    data = resp.body
    result = JSON.parse(data)
    return result
  end
  
  def current_game_version
    game_versions = json_parse("https://na1.api.riotgames.com/lol/static-data/v3/versions?api_key=#{ENV['riot_key']}")
    current_game_version = game_versions[0] #Find most current version of game for updated API
    return "7.15.1" #current_game_version - For some reason Riot current has rate limits on static api calls should return current_game_version
  end
  def retrieve_champion(id)

    champlist = json_parse("http://ddragon.leagueoflegends.com/cdn/#{current_game_version}/data/en_US/champion.json")
    #champlist is a json file of every champ in the game
    #cycle through each champ in champlist["data"], k is the champion, v is the data within the champion
    #v is nested JSON data, look for "key" and match 
    champlist["data"].each do |k, v |
      if v["key"] == id.to_s
        return v
      end
    end
    #If no matches are available, return as "none"
    return "none"
  end
  
  def retrieve_static_summs(id) #Other static data use ID number, but summoners need a different key
    source = "https://na1.api.riotgames.com/lol/static-data/v3/summoner-spells/#{id}?locale=en_US&api_key=#{ENV['riot_key']}"
    summs_info = JSON.parse(File.read "#{Rails.root}/app/helpers/summonerspell.json" )
    summs_info["data"].each do |k, v |
      if v["id"] == id
        return k
      end
    end
  end
  
  def riot_static_img(category, value, imgsize) #Available categories: champion, spell, item, mastery, rune
    return image_tag("http://ddragon.leagueoflegends.com/cdn/#{current_game_version}/img/#{category}/#{value}.png", size: imgsize)
  end
  

end