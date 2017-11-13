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
    playerList = matchinfo["participants"].select{|t| t["teamId"] == teamID}
    playerList.each do |player|
      participant = matchinfo["participantIdentities"].find{|p| p["participantId"] == player["participantId"]}
      participantInfo = participant["player"]
      updatedInfo = player.merge(participantInfo)
      currentPlayer = MatchDetails::MatchParticipant.new
      currentPlayer.generate(updatedInfo)
      teamPlayers["#{currentPlayer.role}"] = currentPlayer
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
    :summonerSpell1,
    :summonerSpell2,
    :masteries,
    :items,
    :kda,
    :damageDealt,
    :amountHealed,
    :damageShielded,
    :goldEarned,
    :creepScore,
    :champlevel,
    :controlWards,
    :wardsPlaced,
    :wardsKilled,
    :creepscorePerMin,
    :creepscoreDiff,
    :expDiff,
    :role,
    :accountID,
    :summonerName
    ) do
    def generate(args)
      self.participantId = args["participantId"]
      self.championId = args["championId"]
      self.summonerSpell1 = args["spell1Id"]
      self.summonerSpell2 = args["spell2Id"]
      self.masteries = args["masteries"]
      self.items = compile_items(args["stats"])
      self.kda = compile_KDA(args["stats"])
      self.damageDealt = args["stats"]["totalDamageDealtToChampions"]
      self.amountHealed = args["stats"]["totalHeal"]
      self.damageShielded = args["stats"]["damageSelfMitigated"]
      self.goldEarned = args["stats"]["goldEarned"]
      self.creepScore = compile_CS(args["stats"])
      self.champlevel = args["stats"]["champLevel"]
      self.controlWards = args["stats"]["visionWardsBoughtInGame"]
      self.wardsPlaced = args["stats"]["wardsPlaced"]
      self.wardsKilled = args["stats"]["wardsKilled"]
      self.creepscorePerMin = compile_csmin(args["timeline"])
      self.creepscoreDiff = compile_CSDiff(args["timeline"])
      self.expDiff = compile_EXPDiff(args["timeline"])
      self.role = find_role(args["timeline"])
      self.accountID = args["accountId"]
      self.summonerName = args["summonerName"]
    end
    
    private
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
    
    def compile_csmin(timeline)
      csMin = {"0-10" => timeline["creepsPerMinDeltas"]["0-10"],
                "10-20" => timeline["creepsPerMinDeltas"]["10-20"],
                "20-30" => timeline["creepsPerMinDeltas"]["20-30"]}
      return csMin
    end
    
    def compile_CSDiff(timeline)
      csDiff = {"0-10" => timeline["csDiffPerMinDeltas"]["0-10"],
                "10-20" => timeline["csDiffPerMinDeltas"]["10-20"],
                "20-30" => timeline["csDiffPerMinDeltas"]["20-30"]}
      return csDiff
    end
    
    def compile_EXPDiff(timeline)
      expDiff = {"0-10" => timeline["xpDiffPerMinDeltas"]["0-10"],
          "10-20" => timeline["xpDiffPerMinDeltas"]["10-20"],
          "20-30" => timeline["xpDiffPerMinDeltas"]["20-30"]}
      return expDiff
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