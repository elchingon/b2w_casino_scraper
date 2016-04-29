class AddWikiUrlAndCountyToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :wiki_url, :string, after: :url
    add_column :venues, :county, :string, after: :phone
  end
end
