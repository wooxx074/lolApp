module ApplicationHelper
  def retrieve_sumn_id(region, sumname)
    source = "https://#{region}.api.riotgames.com/lol/summoner/v3/summoners/by-name/#{sumname}?api_key=#{ENV["riot_key"]}"
    encoded_url = URI.encode(source)
    resp = Net::HTTP.get_response(URI.parse(encoded_url))
    data = resp.body
    result = JSON.parse(data)
  end
end
