#require 'json'
class TicketmasterAPIAccessor < ApiAccessor
  #Some Venue IDs
  # Thunder Valley Casino: KovZpaKoVe
  # Pechanga: ZFr9jZdav6
  # Sycuan: KovZpZA1IJdA

  def self.get_ticketmaster_events(venue_id='KovZpaKoVe', api_key='4fFnCR4ir6TZrWKNKYPAlBfpBJrdKMpo')
    #make sure the venue id is a string and the api_key is a string
    venue = venue_id
    if venue.class == String && api_key.class == String
      #open the link
      access_api('https://app.ticketmaster.com/discovery/v2/events.json?apikey='+api_key+'&venueId='+venue)
      events = parse_ticketmaster_events
      binding.pry
    else
      ticketmaster_connection_logger.info('failed to connect to tickmaster API the API key is:' + api_key + 'the venue id is:' + venue)
    end
  end

  def self.parse_ticketmaster_events
    #this depends on the venue
    @response.parsed_response #.to_json.gsub!(/\"/, '\'')

  end
  def self.ticketmaster_connection_logger
    @venue_update_logs ||= Logger.new("#{Rails.root}/log/ticketmaster_connection.log")
  end
end

