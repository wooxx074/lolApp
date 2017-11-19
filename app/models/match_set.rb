class MatchSet
  include MatchDetails
  attr_reader :matchset
  
  def initialize(player, matchRange)
    @matchset = pull_matches(player, matchRange)
  end
  
  
  private
  def pull_matches(player, matchRange)
    unsortedList = player.matches
    #sort matches by game id because Riot's game ID are chronological
    #simpler sort without digging into the ["match_info"]["gamecreation"] fields
    #reverse so most recent matches come first
    sortedList = unsortedList.sort_by {|match| match["game_id"] }.reverse
    sortedList = sortedList.uniq #Remove any possible duplicates when multiple accounts are queried
    collectedList = []
    sortedList[matchRange].each do |match|
      collectedList << match unless nil
    end
    
    return collectedList
  end
  

end