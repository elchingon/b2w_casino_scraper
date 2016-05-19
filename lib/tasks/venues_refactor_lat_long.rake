namespace :venues do
  desc "Update Venue lat long from wikipedia"
  task refactor_lat_long: :environment do

    venues = Venue.where("latitude_str IS NOT NULL AND longitude_str IS NOT NULL")

    venues.each do |venue|
      latitude, longitude = nil, nil
      lat_str = venue.latitude_str
      long_str = venue.longitude_str

      lat_str.gsub!(/[^0-9]/, "'")
      long_str.gsub!(/[^0-9]/, "'")
      lat_str[0...-1].gsub(/(\d+)'(\d+)'(\d+)'/) do
        latitude = $1.to_f + $2.to_f/60 + $3.to_f/3600
      end
      long_str[0...-1].gsub(/(\d+)'(\d+)'(\d+)'/) do
        longitude =  -$1.to_f + $2.to_f/60 + $3.to_f/3600
      end
      unless latitude.nil? && longitude.nil?
        p "Updating venue id #{venue.id} - #{venue.title}: #{latitude}, #{longitude}"
        venue.update_attributes(latitude: latitude, longitude: longitude)
      end
    end

  end
end