module MatchDetails
  def create_team(matchinfo)
      team = MatchTeam.new
      team.generate(matchinfo)
      return team
  end
  
  def create_team_players(matchinfo, teamID)
    teamPlayers = ["TOP","JUNGLE","MIDDLE","ADC","SUPPORT"]
    
    playerList = matchinfo["participants"].select{|t| t["teamId"] == teamID}
    playerList.each do |player|
      participantInfo = matchinfo["participantIdentities"].find{|p| p["participantId"] == player["participantId"]}
      updatedInfo = matchinfo.merge(participantInfo)
      currentPlayer = MatchParticipant.new
      currentPlayer.generate(updatedInfo)
      teamPlayers.map! { |x| x == currentPlayer.role ? currentPlayer : x }
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
    :KDA,
    :damageDealt,
    :amountHealed,
    :damageShielded,
    :goldEarned,
    :creepScore,
    :champlevel,
    :controlWards,
    :wardsPlaced,
    :wardsKilled,
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
      self.KDA = compile_KDA(args["stats"])
      self.damageDealt = args["stats"]["totalDamageDealtToChampions"]
      self.amountHealed = args["stats"]["totalHeal"]
      self.damageShielded = args["stats"]["damageSelfMitigated"]
      self.goldEarned = args["stats"]["goldEarned"]
      self.creepScore = compile_CS(args["stats"])
      self.champlevel = args["stats"]["champLevel"]
      self.controlWards = args["stats"]["visionWardsBoughtInGame"]
      self.wardsPlaced = args["stats"]["wardsPlaced"]
      self.wardsKilled = args["stats"]["wardsKilled"]
      self.creepscoreDiff = compile_CSDiff(args["stats"])
      self.expDiff = compile_EXPDiff(args["stats"])
      self.role = find_role(args)
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
  end
end