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

      event_data = [{}]
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

end