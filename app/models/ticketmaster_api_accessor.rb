class TicketmasterApiAccessor < ApiAccessor
  #Some Venue IDs

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
      Event.ticketmaster_connection_logger.info('failed to connect to tickmaster API the venue id is:' + venue)
    end
  end

  def create_ticketmaster_events parsed_response
    begin
      json_events = parsed_response['_embedded']['events']
      unless json_events.nil? || json_events.empty? || json_events.length == 0
        Event.ticketmaster_update_logger.info("Found #{json_events.length} Events")

        events_processed, events_imported = 0, 0
        i = 0
        while i < json_events.length
          event = json_events[i]
          event_name = event['name']
          event_start_date = event['dates']['start']['dateTime']
          venue_name = event['_embedded']['venues'][0]['name'] #should be listed off the venue id?




          new_event = Event.find_or_initialize_by(venue_id: @venue_id, title: event_name, start_date: event_start_date)

          Event.ticketmaster_update_logger.info("New Event found from Venue ID #{@venue_id} with event name #{event_name}")

          if new_event.new_record?
            events_imported += 1
            Event.ticketmaster_update_logger.info("Importing event: #{event_name}")
          end

          event['info'].nil? ? Event.ticketmaster_update_logger.info("#{@venue_id} has no event info")  : new_event.update_attributes( description: event['info'])


          event_venue_info = event['_embedded']['venues'][0]
          event_venue_info['location'].nil? ? Event.ticketmaster_update_logger.info("#{@venue_id} has no location info")  : new_event.update_attributes(  longitude: event_venue_info['location']['longitude'], latitude: event_venue_info['location']['latitude'])
          event_venue_info['address']['line1'].nil? ? Event.ticketmaster_update_logger.info("#{@venue_id} has no line1 address info")  : new_event.update_attributes( address1: event_venue_info['address']['line1'])
          event_venue_info['address']['line2'].nil? ? Event.ticketmaster_update_logger.info("#{@venue_id} has no line2 address info")  : new_event.update_attributes( address2: event_venue_info['address']['line2'])

          new_event.update_attributes(
              link_url: event['url'],
              image_url: event['images'][0]['url'],
              city: event_venue_info['city']['name'],
              state: event_venue_info['state']['name'],
              zipcode: event_venue_info['postalCode'],
              country: event_venue_info['country']['countryCode']
          # end_date: end_date TODO: Talk about what we should do about the end time for the ticketmaster events.
          )

          events_processed += 1
          i += 1
        end
        Event.ticketmaster_update_logger.info("  Events Processed: #{events_processed}")
        Event.ticketmaster_update_logger.info("  New Events Imported: #{events_imported}")
      end
    end
  rescue Exception => e
    Event.ticketmaster_update_logger.error(e.inspect)
  end
end

