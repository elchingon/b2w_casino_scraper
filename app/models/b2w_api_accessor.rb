class B2WApiAccessor < ApiAccessor

  def self.get_b2w_api
    access_api('http://api.born2win.club/v1/events')
    binding.pry
    parse_b2w_api
  end

  def self.parse_b2w_api
    b2w_events = @response.to_json.gsub!(/\"/, '\'')
    b2w_events['status']
  end
end