class Venue < ActiveRecord::Base


  def self.load_wiki_venues_list
    begin
      # Call Webparser.parse_casino_list_wiki
      wp = WebParser.new
      results_hash = wp.parse_casino_list_wiki

      # Find OR Create Venues from Casino names in list
      results_hash.each do |venue_hash|
        if venue_hash[:title]
          venue_update_logger.info("Loading Venue by #{venue_hash[:title]}")
          venue = Venue.find_or_initialize_by(title: venue_hash[:title])

          venue_update_logger.info("    New Venue found.") if venue.new_record?
          # update attributes of attributes found
          venue.update_attributes(venue_hash)

          venue_update_logger.info("    Venue Updated")
        end
      end
    rescue Exception => e
      venue_update_logger.error(e.inspect)
      #raise
    end
  end

  def self.update_wiki_venues_attributes
    # Iterate all venues with wiki_url
    # update attributes from wiki page hash
    begin
      wp = WebParser.new

      venues = Venue.where("wiki_url LIKE '%wikipedia.org/wiki%'")
      venues.each do |venue|
        venue_update_logger.info("Updating Venue '#{venue.title}' Attributes")
        result_hash = wp.parse_casino_wiki venue.wiki_url, venue.title
        unless result_hash.empty?
          venue.update_attributes(result_hash)
          venue_update_logger.info("    Venue Updated")
        end

      end
    rescue Exception => e
      venue_update_logger.error(e.inspect)
      #raise
    end
  end


  def self.venue_update_logger
    @venue_update_logs ||= Logger.new("#{Rails.root}/log/venue_updates.log")
  end
  def venue_update_logger
    @venue_update_logs ||= Logger.new("#{Rails.root}/log/venue_updates.log")
  end

end
