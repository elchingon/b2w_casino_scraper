class WikiEvent < WebParser

  def initialize url, url_path
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

    event_url = []
    doc = open_url @web_url + @url_path

    if doc.children && doc.children.length > 1
      results = doc.children[1].at_css(".events-loop")

      unless results.nil?
        results.children.each do |row|
          if !row.at_css(".events-loop-event-title").nil? && row.at_css(".events-loop-event-title").count
            link = row.at_css(".events-loop-event-title")["href"]
            event_url.push(link) if link
          end
        end
        event_url
      end

    end

    #get event array with the event
    event_data = []

    event_url.each do |i|

      doc = open_url i
      result = doc.children
      results = result[1].children

      event_title = result.children[3].children[11].children[3].children[5].children[1].children[3].children[3].content.strip
      event_date = result.children[3].children[11].children[3].children[5].children[1].children[3].children[15].children[5].children[1].content.strip

      unless result.children[3].children[11].children[3].children[5].children[1].children[3].children[15].children[5].children[3].nil?
      event_description = result.children[3].children[11].children[3].children[5].children[1].children[3].children[15].children[5].children[3].content
      end

      unless result.children[3].children[11].children[3].children[5].children[1].children[3].children[15].children[5].children[5].nil?
      event_url = result.children[3].children[11].children[3].children[5].children[1].children[3].children[15].children[5].children[5].at_css('.purple-button-poker')["href"]
      end

      event_start = result.children[3].children[11].children[3].children[5].children[1].children[3].children[15].children[16].children[1].children[3].children[3].children[1].content.strip
      event_end = result.children[3].children[11].children[3].children[5].children[1].children[3].children[15].children[16].children[1].children[3].children[7].children[1].children[0].content.strip

      event_image_url = result.children[3].children[11].children[3].children[5].children[1].children[3].children[1].attribute("src").content
      event_hash = {  'title' => event_title,
                      'event_date' => event_date,
                      'link_url' => event_url,
                      'image_url' => event_image_url,
                      'start_date' => event_start,
                      'end_date' => event_end,
                      'description' => event_description
      }
      event_data << event_hash
    end
    event_data
  end
end