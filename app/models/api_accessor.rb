class ApiAccessor
  include HTTParty

  def self.access_api(url_to_open)
    @response = HTTParty.get(url_to_open)
  end

end