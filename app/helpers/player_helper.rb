module PlayerHelper
  def region_check(region)
    if region == "LCK" then return "kr"
      elsif region == "NA LCS" then return "na1"
      elsif region == "EU LCS" then return "euw1"
    else return "none"
    end
  end 

  def retrieve_sumn_id(region, sumname)
    source = "https://#{region}.api.riotgames.com/lol/summoner/v3/summoners/by-name/#{sumname}?api_key=#{ENV['riot_key']}"
    encoded_url = URI.encode(source)
    resp = Net::HTTP.get_response(URI.parse(encoded_url))
    data = resp.body
    result = JSON.parse(data)["accountId"]
    # Show error code instead of nil for account id
    if result.nil?
      result = 111 #temp error code
    end
    
    return result
  end
end