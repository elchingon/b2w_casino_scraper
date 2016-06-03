class WikiEvent < WebParser

  def initialize url, url_path = ""
    @web_url = url
    @url_path = url_path
  end

  #event = WikiEvent.new "https://www.pechanga.com/", "rest/v2.0/entertainment/api/Entertainment/E?_=1463671134566"
  def parse_pechanga_rest_api
    doc = open_url @web_url + @url_path
    #p doc

    #xpath = "#concerts-result"
    result = doc.children
    results = result[1].children

    json = JSON(results[0].content)
    if json

      event_data = []
      json.each_with_index do |unit, index|
        event_title = unit["Title"].strip
        event_subtitle = unit["Subtitle"].strip
        event_image_url = @web_url + unit["FeatureUrl"].strip
        event_prices = unit["Prices"].strip
        event_end = unit["ExpireDate"].strip
        event_url = @web_url + unit["LinkUrl"].strip
        event_hash = { 'title' => event_title,
                       'dates' => event_subtitle,
                       'end_date' => event_end,
                       'link_url' => event_url,
                       'image_url' => event_image_url,
                       'description' => event_prices
                    }
        event_data <<  event_hash
      end
      event_data
    end
  end


  # Method to parse url event list page info
  # @return event_array with event urls
  def parse_sycuan_event_list

    event_urls = []
    doc = open_url @web_url + @url_path

    if doc.children && doc.children.length > 1
      results = doc.children[1].at_css(".events-loop")

      unless results.nil?
        results.children.each do |row|
          if !row.at_css(".events-loop-event-title").nil? && row.at_css(".events-loop-event-title").count
            link = row.at_css(".events-loop-event-title")["href"]
            event_urls << link if link
          end
        end
        event_urls
      end

    end
  end

  def parse_sycuan_event_page
    #get event array with the event

      doc = open_url @web_url
      result = doc.children
      results = result[1].children

      event_url = @web_url
      event_title = results.at_css(".tribe-events-single-event-title") ? results.at_css(".tribe-events-single-event-title").content : ""
      event_description = results.at_css(".tribe-events-single-event-description") ? results.at_css(".tribe-events-single-event-description").content.strip : ""
      event_image_url = results.at_css("#tribe-events-content img") ? results.at_css("#tribe-events-content img").attr('src') : nil

      if results.css(".dtstart").count > 1
        start_date = results.css(".dtstart").first.content.strip
        event_time = results.css(".dtstart")[1].content.strip
        times = event_time.split("-")
        event_start = "#{start_date} #{times[0].strip}"
        event_end = times.count > 1 ? "#{start_date} #{times[1].strip}" : start_date + 1.day
      else
        event_start = results.at_css(".dtstart") ? results.at_css(".dtstart").content : nil
        event_end = results.at_css(".dtend") ? results.at_css(".dtend").content : nil
      end

      event_hash = {  'title' => event_title,
                      #'event_date' => event_date,
                      'link_url' => event_url,
                      'image_url' => event_image_url,
                      'start_date' => event_start,
                      'end_date' => event_end,
                      'description' => event_description
      }
      event_hash
  end
end