class Player < ApplicationRecord
  attr_accessor :player, :sorted_matches
  extend FriendlyId
  friendly_id :name, use: :slugged
  validates :name, :slug, presence: true
  serialize :summonername, Hash
  belongs_to :team
  has_and_belongs_to_many :matches
  has_attached_file :avatar, 
                    :styles => { medium: "300x300>", thumb: "100x100>" }, 
                    :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
  include MatchMethods #found in /lib
    
  after_initialize do #Any way to have method only called when show page is loading?
    save_player_matches if self.last_regenerated_matches < (DateTime.now - 0.5.hours)
  end
  
  def save_player_matches
    api_beginTime = Float
    case
    when self.last_regenerated_matches.nil? || self.last_regenerated_matches < (DateTime.now - 2.weeks)
      api_beginTime = (DateTime.now.to_f*1000).to_i-1209600000 #dateTime_endpoint is two weeks prior
    when self.last_regenerated_matches < (DateTime.now - 0.5.hours)
      puts "Player's matches recently updated"
      exit
    else
      api_beginTime = (@player.last_regenerated_matches.to_f*1000)-7200000 #Change last_regenerated_matches date to float, subtract by two hours
    end
    league_region = self.team.league.name
    self.summonername.each do |sumname, accountId|
      matchList = generate_api_matches(league_region, accountId, api_beginTime)
      unless matchList["matches"].nil?
        matchList["matches"].each do |game|
          gameId = game["gameId"]
          champPlayed = game["champion"]
          #See if match was already put in database through gameId
          #If match is not found, add match info to Match model
          found_match = Match.find_by_game_id(gameId)
          if found_match.nil?
            game_info = generate_api_match_info(league_region, gameId)
            match_timeline = generate_api_match_timeline(league_region, gameId)
            match_timeline = timeline_trim(match_timeline)
            if game_info["status"].nil? #Check to see whether parsed json is an error
              new_match = Match.new(game_id: gameId,
                                    match_info: game_info, 
                                    match_timeline: match_timeline,
                                    pros_in_game: ["#{accountId}"],
                                    champs_pro_played: [champPlayed])
              new_match.save
              self.matches << new_match
            end
          else
            # If match was already in database (likely regenerated from other pro),
            # add current pro in the pool of pros participated in match
            unless found_match.pros_in_game.include?("#{accountId}")
              found_match.pros_in_game << "#{accountId}"
              found_match.champs_pro_played << champPlayed
              self.matches << found_match
            end
          end
        end
        else
          puts "No matches pulled from API"
      end
    end
  end
  
  # private
  #Currently also in ApplicationHelper. Needs to be DRY
  def generate_api_matches(league_region,accountId, api_beginTime)
    region = region_check(league_region)
    #begin time limits how far back api searches
    #queue 400 = normal 5v5 draft pick
    #queue 420 = 5v5 ranked
    #queue 440 = 5v5 flexed
    source = "https://#{region}.api.riotgames.com/lol/match/v3/matchlists/by-account/#{accountId}?beginTime=#{api_beginTime}&queue=400&queue=420&queue=440&api_key=#{ENV['riot_key']}"
    json = json_parse(source)
    return json
  end
  
  def generate_api_match_info(league_region,gameId)
    region = region_check(league_region)
    source = "https://#{region}.api.riotgames.com/lol/match/v3/matches/#{gameId}?api_key=#{ENV['riot_key']}"
    json = json_parse(source)
    return json
  end
  
  def generate_api_match_timeline(league_region, gameId)
    region = region_check(league_region)
    source = "https://#{region}.api.riotgames.com/lol/match/v3/timelines/by-match/#{gameId}?api_key=#{ENV['riot_key']}"
    json = json_parse(source)
    return json
  end
  
  def timeline_trim(match_timeline)
    new_json = match_timeline["frames"]
    new_json.each do |frame|
        frame.delete("participantFrames")
        frame["events"].delete_if{|event| event["type"] =~ /WARD_PLACED|WARD_KILLCHAMPION_KILL|ITEM_DESTROYED|BUILDING_KILL/i }
    end
    return new_json
  end
end
