require 'open-uri'

class WebParser

  def initialize
    @wiki_url = "https://en.wikipedia.org"
    @casino_list_url = @wiki_url + "/wiki/List_of_casinos_in_the_United_States"
  end


  def parse_casino_list_wiki

    doc = Nokogiri::HTML(open(@casino_list_url))

    xpath_id = ".toccolours"
    result = doc.css(xpath_id)
    unit = result[0]
    if unit
      venue_array = [{}]
      unit.css("tr").each_with_index do |unit_row, index|
        # Skip first row
        if index > 0
          venue_data = {}

          unit_row.css('td').each_with_index do |unit_col, index|

            field_name = casino_table_fields[index]
            if field_name
              if field_name == :title && !unit_col.css("a").empty?
                wiki_link = unit_col.css("a")[0]["href"]

                if wiki_link.include?('wiki') || wiki_link.include?('w/index.php')
                  wiki_link = @wiki_url + wiki_link

                  venue_data[:wiki_url] = wiki_link
                elsif wiki_link.include?('http://')
                  venue_data[:url] = wiki_link
                end

              end

              venue_data[field_name.to_sym] = unit_col.text

            end
          end

          venue_array.push(venue_data) unless venue_data.empty?
        end

      end

      venue_array
    end
  end


  def parse_casino_wiki wiki_url, casino_title

    doc = Nokogiri::HTML(open(wiki_url))

    venue_data = {}

    xpath_id = "#mw-content-text"
    full_result = doc.css(xpath_id)

    #binding.pry
    xpath_id = ".infobox"
    infobox_result = full_result.css(xpath_id)
    unit = infobox_result[0]

    xpath_id = "#firstHeading"
    title_result = doc.css(xpath_id)
    if unit && !title_result.empty?  && !title_result.nil? && title_result[0].text.include?(casino_title)

      images = ""
      unit.css('tr').each_with_index do |unit_col, index|
       # Skip first row
       if index > 0

         if !unit_col.css('th').empty? && unit_col.css('th')[0].text == "Coordinates"
            if !unit_col.css('.latitude').empty?
              latitude = unit_col.css('.latitude')[0].text
              venue_data[:latitude_str] = latitude
              longitude = unit_col.css('.longitude')[0].text
              venue_data[:longitude_str] = longitude
              # TODO convert coords to decimal
            elsif !unit_col.css('td').empty?
              text_value = unit_col.css('td')[0].text
              text_arr = text_value.split(",")
              venue_data[:latitude_str] = text_arr[0]
              venue_data[:longitude_str] = text_arr[1]
            end
         end
         if !unit_col.css('th').empty? && !unit_col.css('a').empty? && unit_col.css('th')[0].text == "Website"
            url_link = unit_col.css("a")[0]["href"]
            venue_data[:url] = url_link
         end

         value_hash = find_value_by_th_label unit_col, 'Opening date', 'opening_date'
         venue_data.merge!(value_hash) unless value_hash.nil?
         value_hash = find_value_by_th_label unit_col, 'Theme', 'theme'
         venue_data.merge!(value_hash) unless value_hash.nil?
         value_hash = find_value_by_th_label unit_col, 'Number of rooms', 'number_of_rooms'
         venue_data.merge!(value_hash) unless value_hash.nil?
         value_hash = find_value_by_th_label unit_col, 'Total gaming space', 'total_gaming_space'
         venue_data.merge!(value_hash) unless value_hash.nil?
         value_hash = find_value_by_th_label unit_col, 'Signature attractions', 'attractions'
         venue_data.merge!(value_hash) unless value_hash.nil?
         value_hash = find_value_by_th_label unit_col, 'Signature attractions', 'attractions'
         venue_data.merge!(value_hash) unless value_hash.nil?
         value_hash = find_value_by_th_label unit_col, 'Casino type', 'casino_type'
         venue_data.merge!(value_hash) unless value_hash.nil?
         value_hash = find_value_by_th_label unit_col, 'Owner', 'owner'
         venue_data.merge!(value_hash) unless value_hash.nil?
         value_hash = find_value_by_th_label unit_col, 'Renovated in', 'renovated_at'
         venue_data.merge!(value_hash) unless value_hash.nil?

         value_hash = find_value_by_xpath unit_col, '.street-address', 'address1'
         venue_data.merge!(value_hash) unless value_hash.nil?
         value_hash = find_value_by_xpath unit_col, '.org', 'owner'
         venue_data.merge!(value_hash) unless value_hash.nil?
         value_hash = find_value_by_xpath unit_col, '.locality', 'locality'
         venue_data.merge!(value_hash) unless value_hash.nil?

         unless unit_col.css('.image').empty?

          unit_col.css('.image').each do |image_col|
            images += (images.blank? ? "" : ",") + "https:" + image_col.at_css('img')['src']
          end

         end

       end

      end

      venue_data[:photo_urls] = images
    end

    # look for first paragraph
    xpath_id = "p"
    description_result = full_result.css(xpath_id)
    if description_result && !description_result.empty?
      description_unit = description_result[0]
      if description_unit
        venue_data.merge!({ summary: description_unit.text })
      end
    end

    venue_data
  end

  # @return Hash
  def find_value_by_xpath css_object, xpath_id, field_name

    unless css_object.css(xpath_id).empty? || css_object.css(xpath_id).nil?
      text_value = css_object.css(xpath_id)[0].text
      xpath_hash = {}
      xpath_hash[field_name.to_sym] = text_value
      xpath_hash
    end
  end

  # @return Hash
  def find_value_by_th_label css_object, label, field_name

    if !css_object.css('th').empty? && !css_object.css('td').empty? && css_object.css('th')[0].text == label
      text_value = css_object.css('td')[0].text
      xpath_hash = {}
      xpath_hash[field_name.to_sym] = text_value
      xpath_hash
    end
  end


  # Method to return ordered values to map html td to venue table names
  # @return Array
  def casino_table_fields
    [ :title, :city, :county, :state, :district, :owner_type, :comments ]
  end

end


