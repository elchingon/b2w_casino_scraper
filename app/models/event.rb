class Event < ActiveRecord::Base

  def self.import_pechange_events
    pechanga_id = 136
    wiki_event = WikiEvent.new "https://www.pechanga.com/", "rest/v2.0/entertainment/api/Entertainment/E?_=1463671134566"

    events_array = wiki_event.parse_pechanga_rest_api

    events_array.each do |event_hash|

      if event_hash && event_hash['title']

        dates = event_hash['dates']
        new_dates = dates.split(/([pm|am],)/).each_slice(2).map(&:join)

        new_dates.each do |date|
          start_date = date.to_datetime.to_formatted_s(:db)

          event = Event.find_or_initialize_by(venue_id: pechanga_id, title: event_hash['title'], start_date: start_date)

          event.update_attributes(
              description: event_hash['description'],
              end_date: event_hash['end_date'],
              link_url: event_hash['link_url'],
              image_url: event_hash['image_url'],
          )
        end unless new_dates.empty?
      end

    end unless events_array.empty?
  end
end
