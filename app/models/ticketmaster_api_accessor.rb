require 'json'
class TicketmasterApiAccessor < ApiAccessor
  #Some Venue IDs
  # Thunder Valley Casino: KovZpaKoVe
  # Pechanga: ZFr9jZdav6
  # Sycuan: KovZpZA1IJdA
  def initialize venue_id
    @api_key = ENV['ticketmaster_api_key']
    @venue_id = venue_id

  end

  def get_ticketmaster_events
    #make sure the venue id is a string and the api_key is a string
    @venue_id
    #binding.pry
    if @venue_id.is_a?(String)
      #open the link
      access_api('https://app.ticketmaster.com/discovery/v2/events.json?apikey='+@api_key+'&venueId=' +@venue_id)
    else
      ticketmaster_connection_logger.info('failed to connect to tickmaster API the venue id is:' + venue)
    end
  end

  def create_ticketmaster_events parsed_response
    begin
    json_events = parsed_response['_embedded']['events']
    events_processed, events_imported = 0, 0
      i = 0
      while i < json_events.length
        event = json_events[i]

        event_name = event['name']
        event_start_date = event['dates']['start']['dateTime']
        venue_name = event['_embedded']['venues'][0]['name'] #should be listed off the venue id?

        event['_embedded']['venues'][0]['address']['line2'].nil? ? address_line_2 = ' ' : address_line_2 = event['_embedded']['venues'][0]['address']['line2']

        new_event = Event.find_or_initialize_by(venue_id: @venue_id, title: event_name, start_date: event_start_date)

        if new_event.new_record?
          events_imported += 1
        end



        new_event.update_attributes(
            description: event['info'],
            link_url: event['url'],
            image_url: event['images'][0]['url'],
            city: event['_embedded']['venues'][0]['city']['name'],
            state: event['_embedded']['venues'][0]['state']['name'],
            zipcode: event['_embedded']['venues'][0]['postalCode'],
            country: event['_embedded']['venues'][0]['country']['countryCode'],
            longitude: event['_embedded']['venues'][0]['location']['longitude'],
            latitude: event['_embedded']['venues'][0]['location']['latitude'],
            address1: event['_embedded']['venues'][0]['address']['line1'],
            address2: address_line_2
        # end_date: end_date TODO: Talk about what we should do about the end time for the ticketmaster events.
        )

        events_processed += 1
        i += 1
      end
    Event.ticketmaster_update_logger.info("  Events Processed: #{events_processed}")
    Event.ticketmaster_update_logger.info("  New Events Imported: #{events_imported}")
    end
  rescue Exception => e
    Event.ticketmaster_update_logger.error(e.inspect)
  end
end

