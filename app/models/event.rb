class Event < ActiveRecord::Base
  scope :with_date_from, ->(time) { where("events.start_date > ?", time) if time.present? }

  include MethodLogger
  logger_name "event_update_logger"

  def self.import_pechanga_events
    begin
      #event_update_logger = logger('event_logger')
      events_processed, events_imported = 0, 0

      pechanga_id = 136
      logger.info("Starting Pechanga Event Import - venue_id #{pechanga_id}")

      wiki_event = WikiEvent.new "https://www.pechanga.com/", "rest/v2.0/entertainment/api/Entertainment/E?_=1463671134566"
      events_array = wiki_event.parse_pechanga_rest_api

      logger.info("    #{events_array.length} Events Found")

      events_array.each do |event_hash|

        if event_hash && event_hash['title']


          dates = event_hash['dates']
          new_dates = dates.split(/([pm|am],)/).each_slice(2).map(&:join)

          logger.info("    Parsing #{event_hash['title']} Event with #{new_dates.length} different start_dates")

          new_dates.each do |date|
            start_date = date.to_datetime.to_formatted_s(:db)

            logger.info("    Loading Event Start Date: #{start_date}")

            event = Event.find_or_initialize_by(venue_id: pechanga_id, title: event_hash['title'], start_date: start_date)

            if event.new_record?
              logger.info("  New Event - Title #{event_hash['title']}")
              events_imported += 1
            end

            event.update_attributes(
                description: event_hash['description'],
                end_date: event_hash['end_date'],
                link_url: event_hash['link_url'],
                image_url: event_hash['image_url'],
            )
            events_processed += 1
          end unless new_dates.empty?
        end

      end unless events_array.empty?

      logger.info("  Events Processed: #{events_processed}")
      logger.info("  New Events Imported: #{events_imported}")
    rescue Exception => e
      logger.error(e.inspect)
      #raise
    end
  end


  def self.import_sycuan_events
    begin
      events_processed, events_imported = 0, 0
      sycuan_id = 305

      logger.info("Starting Sycuan Event ID #{sycuan_id}")

      wiki_event = WikiEvent.new "http://www.sycuan.com/", "events/"

      event_array = wiki_event.parse_sycuan_event_list

      logger.info("  #{event_array.length} Event URls Found")

      event_array.each do |event_url|
        if event_url

          wiki_event_page = WikiEvent.new event_url
          event_hash = wiki_event_page.parse_sycuan_event_page

          if event_hash && event_hash['title']
            start_date = event_hash['start_date'].to_datetime.to_formatted_s(:db)
            end_date = event_hash['end_date'].to_datetime.to_formatted_s(:db)

            event = Event.find_or_initialize_by(venue_id: sycuan_id, title: event_hash['title'], start_date: start_date)

            if event.new_record?
              logger.info("  New Event - Title #{event_hash['title']}")
              events_imported += 1
            end

            event.update_attributes(
                description: event_hash['description'],
                link_url: event_hash['link_url'],
                image_url: event_hash['image_url'],
                end_date: end_date
            )

            events_processed += 1
          end
        end
      end

      #wiki_event_details = WikiEvent.new "http://www.sycuan.com", "+ url
      #Method to parse event detail
      logger.info("  Events Processed: #{events_processed}")
      logger.info("  New Events Imported: #{events_imported}")
    rescue Exception => e
      logger.error(e.inspect)


    end
  end
  def self.import_b2w_events
    @b2w_url = "http://api.born2win.club/v1/events"
    b2w_events = ApiAccessor.new @b2w_url, " "
    access_api = b2w_events.access_api(@b2w_url)
    # this works,
    # parsed_events = b2w_events.parse_api #tada.
    # more explicit would be

    parsed_events = access_api.to_json.gsub!(/\"/, '\'') #not certain what is better?
  end

  def self.import_ticketmaster_events
    # Thunder Valley Casino: KovZpaKoVe
    # Pechanga: ZFr9jZdav6
    # Sycuan: KovZpZA1IJdA
    # Harrahs Event Center: KovZpZAEknFA
    @event_ids = ['KovZpZAEknFA' ]
    @event_ids.each do |event_id|
      ticketmaster_events = TicketmasterApiAccessor.new event_id
      parsed_events = ticketmaster_events.get_ticketmaster_events
      ticketmaster_events.create_ticketmaster_events parsed_events
    end
  end

  def self.post_b2w_events

    @future_events = Event.with_date_from(Time.now)
    @future_events.each do |event|
      @event = event
      b2w_poster = EventSubmitter.new @api_key
      b2w_post = b2w_poster.post_event @event
    end
  end
  #def self.event_update_logger
  #  @event_update_logs ||= Logger.new("#{Rails.root}/log/event_updates.log")
  #end
  #def event_update_logger
  #  @event_update_logs ||= Logger.new("#{Rails.root}/log/event_updates.log")
  #end
end
