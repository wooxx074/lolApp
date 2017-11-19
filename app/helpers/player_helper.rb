module PlayerHelper
  # Identifiy which participant is the player
  def generate_player_stats(match, player)
    allParticipants = []
    [match.team1players, match.team2players].each do |team|
      team.each do |role, data|
        allParticipants << data unless data.nil?
      end
    end
    result = nil
    player.summonername.each do |name, id|
      #if nil, will skip and not override resuults for each summonername
      result ||= allParticipants.find {|p| p.accountId == id}
    end
    return result
  end
  
  def player_team(player_stats, match)
    if player_stats.team == 1 ; return match.team1 else return match.team2 end
  end
  

  def find_player_participation_id(current_game, current_account_id)
    if current_game.pros_in_game.include? current_account_id.to_s
      current_game["match_info"]["participantIdentities"].each do |participant| #Cycle through participants to find matching ID
        if participant["player"]["currentAccountId"] == current_account_id
          participantId = participant["participantId"]  #If match, save for future reference
          return participantId #Break method and return value as soon as ID is found
        else
          next
        end
      end
    end
  end


end
