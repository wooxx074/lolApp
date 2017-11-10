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
  

  def save_player_matches
    # If it has been 30 minutes since the last regeneration, proceed

    if @player.last_regenerated_matches.nil? || @player.last_regenerated_matches < (DateTime.now - 0.5.hours)
      #determine DateTime endpoint as last_regenerated_matches (minus 2 hours as cushion).
      #Endpoint will be 2 weeks back if last_regenerated_matches is nil or past 2 weeks
      dateTime_endpoint = 0
      if @player.last_regenerated_matches.nil? || @player.last_regenerated_matches < (DateTime.now - 2.weeks)
        dateTime_endpoint = (DateTime.now.to_f*1000).to_i-1209600000
      else
        dateTime_endpoint = (@player.last_regenerated_matches.to_f*1000).to_i-7200000
      end
      # Find League by player's team ID
      league = League.find(@player.team.league_id)
      region = region_check(league.name) #Convert region to fit Riot API url
      # Will pull match history for each summonername listed in Player
      @player.summonername.each do |sumname, accountId|
        # Pulls Riot API matchlist, beginning from two weeks back. Ordered by most recent first.
        source = "https://#{region}.api.riotgames.com/lol/match/v3/matchlists/by-account/#{accountId}?beginTime=#{dateTime_endpoint}&api_key=#{ENV['riot_key']}"
        matchList = json_parse(source)
        # If no matchList created (API error typically), will not proceed
        unless matchList["matches"].nil?
          matchList["matches"].each do |game|
            gameId = game["gameId"].to_s
            champPlayed = game["champion"]
            found_match = Match.find_by_game_id(gameId) #See if match was already put in database
            if found_match.nil? #If match is not found, add match info to Match model
              source = "https://#{region}.api.riotgames.com/lol/match/v3/matches/#{gameId}?api_key=#{ENV['riot_key']}"
              game_info = json_parse(source)
              if game_info["status"].nil? #Check to see whether parsed json is an error
                new_match = Match.new(match_info: game_info, game_id: gameId)
                new_match.pros_in_game << "#{accountId}" #Adds current pro in the pool of pros participated in match
                new_match.champs_pro_played << champPlayed
                new_match.save
                @player.matches << new_match
              end
            else
              # If match was already in database (likely regenerated from other pro),
              # add current pro in the pool of pros participated in match
              unless found_match.pros_in_game.include?("#{accountId}")
                found_match.pros_in_game << "#{accountId}"
                found_match.champs_pro_played << champPlayed
                @player.matches << found_match
              end
            end
          end
          @player.last_regenerated_matches = DateTime.now #Update the time in which this was last regenerated
          @player.save
          return "Updated" #Filler text to show method has been used
        else
          puts "No match list generated"
          return "" #Return nothing if no match list has been generated
        end
      end

    end
  end
  
  
  
end
