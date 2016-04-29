class AddDistrictAndCoordinatesToVenue < ActiveRecord::Migration
  def change
    add_column :venues, :district, :string, after: :county
    add_column :venues, :latitude_str, :string, after: :longitude
    add_column :venues, :longitude_str, :string, after: :latitude_str
  end
end
