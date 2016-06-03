class Event < ActiveRecord::Base

  def self.import_pechanga_events
    begin
      events_processed, events_imported = 0, 0

      pechanga_id = 136
      event_update_logger.info("Starting Pechanga Event Import - venue_id #{pechanga_id}")

      wiki_event = WikiEvent.new "https://www.pechanga.com/", "rest/v2.0/entertainment/api/Entertainment/E?_=1463671134566"
      events_array = wiki_event.parse_pechanga_rest_api

      event_update_logger.info("    #{events_array.length} Events Found")

      events_array.each do |event_hash|

        if event_hash && event_hash['title']


          dates = event_hash['dates']
          new_dates = dates.split(/([pm|am],)/).each_slice(2).map(&:join)

          event_update_logger.info("    Parsing #{event_hash['title']} Event with #{new_dates.length} different start_dates")

          new_dates.each do |date|
            start_date = date.to_datetime.to_formatted_s(:db)

            event_update_logger.info("    Loading Event Start Date: #{start_date}")

            event = Event.find_or_initialize_by(venue_id: pechanga_id, title: event_hash['title'], start_date: start_date)

            if event.new_record?
              event_update_logger.info("  New Event - Title #{event_hash['title']}")
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

        event_update_logger.info("  Events Processed: #{events_processed}")
        event_update_logger.info("  New Events Imported: #{events_imported}")
    rescue Exception => e
      event_update_logger.error(e.inspect)
      #raise
    end
  end


  def self.import_sycuan_events
    begin
      events_processed, events_imported = 0, 0
      sycuan_id = 305

      event_update_logger.info("Starting Sycuan Event ID #{sycuan_id}")

      wiki_event = WikiEvent.new "http://www.sycuan.com/", "events/"

      event_array = wiki_event.parse_sycuan_event_list

      event_update_logger.info("  #{event_array.length} Event URls Found")

      event_array.each do |event_url|
        if event_url == "http://www.sycuan.com/event/the-manhattan-transfer/"

          wiki_event_page = WikiEvent.new event_url
          event_hash = wiki_event_page.parse_sycuan_event_page

          if event_hash && event_hash['title']
            start_date = event_hash['start_date'].to_datetime.to_formatted_s(:db)
            end_date = event_hash['end_date'].to_datetime.to_formatted_s(:db)

            event = Event.find_or_initialize_by(venue_id: sycuan_id, title: event_hash['title'], start_date: start_date)

            if event.new_record?
              event_update_logger.info("  New Event - Title #{event_hash['title']}")
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
      event_update_logger.info("  Events Processed: #{events_processed}")
      event_update_logger.info("  New Events Imported: #{events_imported}")
    rescue Exception => e
      event_update_logger.error(e.inspect)


    end
  end
  def self.event_update_logger
    @event_update_logs ||= Logger.new("#{Rails.root}/log/event_updates.log")
  end
  def event_update_logger
    @event_update_logs ||= Logger.new("#{Rails.root}/log/event_updates.log")
  end
end
