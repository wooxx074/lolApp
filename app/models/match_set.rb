class MatchSet
  include MatchDetails
  
  def pull_matches(player, numOfMatches)
    #sort matches by game id because Riot's game ID are chronological
    #simpler sort without digging into the ["match_info"]["gamecreation"] fields
    #reverse so most recent matches come first
    matchList = sortedMatches(player)
    sortedList = matchList.first(numOfMatches)
    parsedList = matchParse(sortedList)
    return parsedList
  end

  
  private
  def sortedMatches(player)
    #Classes created from match_components.rb
    unsortedList = player.matches
    sortedList = unsortedList.sort_by {|match| match["game_id"].to_i }.reverse #sorts most recent to least
    sortedList = sortedList.uniq #Remove any possible duplicates when multiple accounts are queried
  end
  

end