class MatchTeam
  attr_accessor :win, 
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
  
  def initialize(args)
    @win = win?(args["win"]) #Convert string ("Win"/"Fail") to a boolean
    @bans = create_ban_list(args["bans"]) #Convert bans to an array with only champ IDs
    @firstBlood = args["firstBlood"]
    @firstTower = args["firstTower"]
    @towerKills = args["towerKills"]
    @inhibitorKills = args["inhibitorKills"]
    @firstBaron = args["firstBaron"]
    @baronKills = args["baronKills"]
    @firstDragon = args["firstDragon"]
    @dragonKills = args["dragonKills"]
    @firstRiftHerald = args["firstRiftHerald"]
    @riftHeraldKills = args["riftHeraldKills"]
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