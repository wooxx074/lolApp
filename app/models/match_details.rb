module MatchDetails
  def create_team(matchinfo, teamnumber)
      teamnumber -= 1 #account for array starting at 0
      team = MatchTeam.new
      team.generate(matchinfo["teams"][teamnumber])
      return team
  end
  
  def create_team_players(matchinfo, teamID)
    teamPlayers = { "TOP" => nil,
                    "JUNGLE" => nil,
                    "MID" => nil,
                    "ADC" => nil,
                    "SUPPORT" => nil }
    #Empty array to fit players that don't fit a role
    undef_role_players = []
    #Find all players on specific team
    playerList = matchinfo["participants"].select{|t| t["teamId"] == teamID}
    playerList.each do |player|
      #Participant Identity info and match data are in separate hash keys. Combining both into updatedInfo
      participant = matchinfo["participantIdentities"].find{|p| p["participantId"] == player["participantId"]}
      participantInfo = participant["player"]
      updatedInfo = player.merge(participantInfo)
      #For each player, create a new MatchParticipant struct from MatchDetails
      currentPlayer = MatchDetails::MatchParticipant.new
      currentPlayer.generate(updatedInfo)
      #See if role of player fits the teamPlayers roles. If true and role is empty, fill hash slot with currentPlayer
      if teamPlayers.key?("#{currentPlayer.role}") && teamPlayers["#{currentPlayer.role}"].nil?
        teamPlayers["#{currentPlayer.role}"] = currentPlayer
        else
        #Else if there's no fit, put currentPlayer in undef_role_players array to be filled later
        undef_role_players << currentPlayer unless currentPlayer.nil?
      end
    end
    #Fill players with undefined roles. 
    #Will not be exact, but ensures all players will be shown in match info
    teamPlayers.each do |role, data|
      if data.nil? 
        teamPlayers[role] = undef_role_players[0]
        undef_role_players.delete_at(0)
      end
    end
    return teamPlayers
  end
  
  
  
  MatchTeam = Struct.new(  
    :win, 
    :bans,
    :firstBlood,
    :firstTower,
    :towerKills,
    :inhibitorKills,
    :firstBaron,
    :baronKills,
    :firstDragon,
    :dragonKills,
    :firstRiftHerald,
    :riftHeraldKills
    ) do
    def generate(args)
      self.win = win?(args["win"]) #Convert string ("Win"/"Fail") to a boolean
      self.bans = create_ban_list(args["bans"]) #Convert bans to an array with only champ IDs
      self.firstBlood = args["firstBlood"]
      self.firstTower = args["firstTower"]
      self.towerKills = args["towerKills"]
      self.inhibitorKills = args["inhibitorKills"]
      self.firstBaron = args["firstBaron"]
      self.baronKills = args["baronKills"]
      self.firstDragon = args["firstDragon"]
      self.dragonKills = args["dragonKills"]
      self.firstRiftHerald = args["firstRiftHerald"]
      self.riftHeraldKills = args["riftHeraldKills"]
    end  
    
  private
    def win?(arg)
      arg.to_s == "Win"
    end
    
    def create_ban_list(bans)
      ban_list = []
      bans.to_a.each do |ban|
        ban_list << ban["championId"]
      end
      return ban_list
    end
  end
  
  
  MatchParticipant = Struct.new(
    :participantId,
    :championId,
    :team,
    :summonerSpell1,
    :summonerSpell2,
    :runes,
    :items,
    :kda,
    :largestMultiKill,
    :damageDealt,
    :amountHealed,
    :damageShielded,
    :goldEarned,
    :creepScore,
    :champLevel,
    :controlWards,
    :wardsPlaced,
    :wardsKilled,
    :creepscorePerMin,
    :creepscoreDiff,
    :expDiff,
    :role,
    :accountId,
    :summonerName
    ) do
    def generate(args)
      self.participantId = args["participantId"]
      self.championId = args["championId"]
      self.team = args["teamId"]/100#Change team ID from e.g. 100 to 1
      self.summonerSpell1 = args["spell1Id"]
      self.summonerSpell2 = args["spell2Id"]
      self.runes = compile_runes(args["stats"])
      self.items = compile_items(args["stats"])
      self.kda = compile_KDA(args["stats"])
      self.largestMultiKill = args["stats"]["largestMultiKill"]
      self.damageDealt = args["stats"]["totalDamageDealtToChampions"]
      self.amountHealed = args["stats"]["totalHeal"]
      self.damageShielded = args["stats"]["damageSelfMitigated"]
      self.goldEarned = args["stats"]["goldEarned"]
      self.creepScore = compile_CS(args["stats"])
      self.champLevel = args["stats"]["champLevel"]
      self.controlWards = args["stats"]["visionWardsBoughtInGame"]
      self.wardsPlaced = args["stats"]["wardsPlaced"]
      self.wardsKilled = args["stats"]["wardsKilled"]
      self.creepscorePerMin = compile_stat_deltas(args["timeline"]["creepsPerMinDeltas"])
      self.creepscoreDiff = compile_stat_deltas(args["timeline"]["csDiffPerMinDeltas"])
      self.expDiff = compile_stat_deltas(args["timeline"]["xpDiffPerMinDeltas"])
      self.role = find_role(args["timeline"])
      self.accountId = args["accountId"]
      self.summonerName = args["summonerName"]
    end
    
    private
    def compile_runes(stats)
      perks = {}
      perks["primary"] = [stats["perkPrimaryStyle"],[]]
      (0..3).each do |i|
        perks["primary"][1] << stats["perk#{i}"]
      end
      perks["secondary"] = [stats["perkSubStyle"], []]
      (4..5).each do |i|
        perks["secondary"][1] << stats["perk#{i}"]
      end
      #Cycle through perk0 to perk5 and assign each to hash
      return perks
    end
    def compile_items(stats)
      itemArray = []
      (0..5).each do |x|
        unless stats["item#{x}"] == 0
          itemArray << stats["item#{x}"]
        end
      end
      until itemArray.count == 6
        itemArray << 0  
      end
      itemArray << stats["item6"]
      return itemArray
    end
    
    def compile_KDA(stats)
      kda = { "kills" => stats["kills"],
              "deaths" => stats["deaths"],
              "assists" => stats["assists"] }
      return kda
    end
    
    def compile_CS(stats)
      minionKills = stats["totalMinionsKilled"]
      neutralMonsterKills = stats["neutralMinionsKilled"]
      totalCS = minionKills + neutralMonsterKills
      return totalCS
    end
    
    def compile_stat_deltas(delta_stats)
      statHash = {}
      delta_stats = delta_stats.to_h
      time_windows = ["0-10", "10-20", "20-30", "30-40", "40-50", "50-60"]
      time_windows.each do |window|
        stat = delta_stats[window] ||= 0
        stat = stat.round(2)
        statHash[window] = stat
      end
      return statHash
    end
    
    def find_role(timeline)
      case
      when timeline["lane"] == "TOP"
        return "TOP"
      when timeline["lane"] == "JUNGLE"
        return "JUNGLE"
      when timeline["lane"] == "MIDDLE"
        return "MID"
      when timeline["role"] == "DUO_CARRY"
        return "ADC"
      when timeline["role"] == "DUO_SUPPORT"
        return "SUPPORT"
      else
        return nil
      end
    end
  end
  
  def find_img(data, type)
    case
    when type =="champion"
      stuff
    when type == "summonerSpell"
      stuff
    when type == "item"
      stuff
    when type == "mastery"
      stuff
    when type == ""
      stuff
    end
  end
end