class MatchSetup
  
  def pull_matches(player, numOfMatches)
    #sort matches by game id because Riot's game ID are chronological
    #simpler sort without digging into the ["match_info"]["gamecreation"] fields
    #reverse so most recent matches come first
    matchList = sortedMatches(player)
    sortedList = matchList.first(numOfMatches)
    parsedList = matchParse(sortedList)
    return parsedList
  end
  
  def matchParse(matchList)
    parsedMatches = []
    matchList.each do |match|
      currentMatch = MatchView.new(
        :gameId => match.gameId
        )
      parsedMatches << currentMatch
    end
    return parsedMatches
  end
  
  private
  def sortedMatches(player)
    #Classes created from match_components.rb
    unsortedList = player.matches
    sortedList = unsortedList.sort_by {|match| match["game_id"].to_i }.reverse #sorts most recent to least
    sortedList = sortedList.uniq #Remove any possible duplicates when multiple accounts are queried
  end
  

end