module MatchHelper
  def retrieve_champion(id)
  champlist = json_parse("http://ddragon.leagueoflegends.com/cdn/#{current_game_version}/data/en_US/champion.json")
    #champlist is a json file of every champ in the game
    #data is nested JSON, find "key" that matches id
    championData = champlist["data"].find{|champ, data| data["key"] == "#{id}"}
    #If no matches are available, return as "none"
    return championData[1]
  end
  def retrieve_summoner(id)
    summlist = json_parse("http://ddragon.leagueoflegends.com/cdn/#{current_game_version}/data/en_US/summoner.json")
    summData = summlist["data"].find{|summ, data| data["key"] == "#{id}"}
    return summData[1]
  end
  def riot_static_img(category, value, imgsize) #Available categories: champion, spell, item, mastery, rune
    return image_tag("http://ddragon.leagueoflegends.com/cdn/#{current_game_version}/img/#{category}/#{value}.png", size: imgsize)
  end
  
  def find_lane_opponent(game, participantId, participant_role)
    participant_range = (1..10)
    if participantId > 6
      participant_range = (1..5)
    else
      participant_range = (6..10)
    end
    participant_range.each do |n|
      opponent = game["match_info"]["participants"][n]["timeline"]
      find_participant_role(opponent)
    end #TO DO SEE IF OPPONENT ROLE MATCHES PARTICIPANT ROLE
  end

end