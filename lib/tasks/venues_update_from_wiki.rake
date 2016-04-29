namespace :venues do
  desc "Update Venue info from wikipedia"
  task update_from_wiki: :environment do

    Venue.load_wiki_venues_list

  end
end