class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  def region_check(region)
    case region
    when "LCK"
      return "kr"
    when "NA LCS"
      return "na1"
    when "EU LCS"
      return "euw"
    else 
      return "none"
    end
  end
  
  def retrieve_sumn_id(region, sumname)
    source = "https://#{region}.api.riotgames.com/lol/summoner/v3/summoners/by-name/#{sumname}?api_key=#{ENV['riot_key']}"
    result = json_parse(source)["accountId"]
    # Show error code instead of nil for account id
    if result.nil?
      result = 111 #temp error code
      puts "Summoner ID Not found"
    end

    return result
  end
end
