class TicketmasterApiAccessor < ApiAccessor
  #Some Venue IDs
  include MethodLogger
  logger_name("ticketmaster_logger")

  def initialize venue_id
    @api_key = ENV['ticketmaster_api_key']
    @venue_id = venue_id

  end

  def get_ticketmaster_events
    #make sure the venue id is a string and the api_key is a string
    @venue_id
      #open the link
      access_api("https://app.ticketmaster.com/discovery/v2/events.json?apikey=#{@api_key}&venueId=#{@venue_id}")
      if @response.nil?
        nil
      else
        @response
      end
  end

  def create_ticketmaster_events parsed_response
    ticket_logger = logger("ticketmaster_logger")
    begin
      json_events = parsed_response['_embedded']['events']
      unless json_events.nil? || json_events.empty? || json_events.length == 0
        ticket_logger.info("Found #{json_events.length} Events")

        events_processed, events_imported = 0, 0

        json_events.each do |event|
          the_event = event #stepping on naming toes. Woops.
          event_name = the_event['name']
          event_start_date = the_event['dates']['start']['dateTime']
          venue_name = the_event['_embedded']['venues'][0]['name'] #should be listed off the venue id?

          new_event = Event.find_or_initialize_by(ticketmaster_event_id: the_event.fetch('id'))
          ticket_logger.info("New Event found from Venue ID #{@venue_id} with event name #{event_name}")

          if new_event.new_record?
            events_imported += 1
           ticket_logger.info("Importing event: #{event_name}")
          end

          @event_hash = {}

          info = the_event.fetch('info') {}

          unless info.nil? #unless info.nil is true do nothing. If
            @event_hash.merge!(description: info) #if false add description
          end

          event_venue_info = the_event.fetch('_embedded').fetch('venues').fetch(0) {} # the nested event_venue_info
          location = event_venue_info.fetch('location') {} #now the nested location

          unless location.nil?
            @event_hash.merge!(latitude: location.fetch('latitude'))
            @event_hash.merge!(longitude: location.fetch('longitude'))
          end

          address = event_venue_info['address']
          address_line_1 = address.fetch('line1') {}
          address_line_2 = address.fetch('line2') {}
          unless address_line_1.nil?
            @event_hash.merge!(address1: address_line_1)
          end
          unless address_line_2.nil?
            @event_hash.merge!(address2: address_line_2)
          end

          @event_hash.merge!(title: the_event['name'],
                             link_url: the_event['url'],
                             image_url: the_event['images'][0]['url'],
                             city: event_venue_info['city']['name'],
                             state: event_venue_info['state']['name'],
                             zipcode: event_venue_info['postalCode'],
                             country: event_venue_info['country']['countryCode'])
                              # end_date: end_date TODO: Talk about what we should do about the end time for the ticketmaster events)

          new_event.update_attributes(@event_hash)

          events_processed += 1
        end
        ticket_logger.info("  Events Processed: #{events_processed}")
        ticket_logger.info("  New Events Imported: #{events_imported}")
      end
    end
  rescue Exception => e
    ticket_logger.error(e.inspect)
  end
end

