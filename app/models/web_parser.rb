require 'open-uri'

class WebParser

  def open_url url
    Nokogiri::HTML(open(url))
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

end


