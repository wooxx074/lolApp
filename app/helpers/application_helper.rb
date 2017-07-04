module ApplicationHelper
  def retrieve_sumn_id(region, sumname)
    source = 'https://#{region}.api.riotgames.com/lol/summoner/v3/summoners/by-name/#{sumname}?api_key=riot_key'
    resp = Net::HTTP.get_response(URI.parse(source))
    data = resp.body
    result = JSON.parse(data)
  end
end
