class Match < ApplicationRecord
  require 'match_details'
  include MatchDetails
  serialize :match_info, JSON
  serialize :pros_in_game, Array
  serialize :champs_pro_played, Array
  validates_uniqueness_of :game_id
  has_and_belongs_to_many :players
  
  # Dynamically initialize and set match_info JSON variables for simpler access
  # def generate_match_details
  #   matchInfo = MatchInfo.new(match_detail_arguments(self.match_info))
  #   return matchInfo
  # end
  after_initialize do
    args = match_detail_arguments(self.match_info)
    init_match_details(args)
    create_attr_reader_methods(args)
    self.match_info = nil #remove json from model initialize for simpler reference
  end
  private
  # Hash to organize JSON hash data for match details
  
  def match_detail_arguments(match)
    match_detail_args={
      gameId: match["gameId"],
      region: match["platformId"], #e.g. NA1
      gameTime: match["gameDuration"], #gameTime currently in seconds, need to convert to minutes
      patchVersion: match["gameVersion"].first(4), #Only first four to match Riot patch versions
      team1: create_team(match, 1),
      team1players: create_team_players(match, 100),
      team2: create_team(match, 2),
      team2players: create_team_players(match, 200)
    }
    return match_detail_args
  end
  
  
  
  def init_match_details(args)
    args.each do |k,v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end
  end
  
  def create_attr_reader_methods(args)
    args.each do |key, val|
      define_singleton_method(key) { instance_variable_get"@#{key}" } 
    end
  end
  
  
end