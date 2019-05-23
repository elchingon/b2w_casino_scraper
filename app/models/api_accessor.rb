class ApiAccessor
  include HTTParty

  def initialize url, api_key
      @web_url = url
      @api_key = api_key
  end

  def access_api url
    @response = HTTParty.get(url)
  end

  def parse_api
    @parsed_response = @response.to_json.gsub!(/\"/, '\'') # parse the API return the JSON
  end

  def post_to_api url, event_json
    HTTParty.post(url, event_json)
  end
end