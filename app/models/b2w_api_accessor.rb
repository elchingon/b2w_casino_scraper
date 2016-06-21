class B2wApiAccessor < ApiAccessor

  def initialize url, api_key
    @web_url = url
    @api_key = api_key
  end

  def get_b2w_api
    access_api(@web_url)
    parse_api
  end

end