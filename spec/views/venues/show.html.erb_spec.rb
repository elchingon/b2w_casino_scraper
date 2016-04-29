require 'rails_helper'

RSpec.describe "venues/show", type: :view do
  before(:each) do
    @venue = assign(:venue, Venue.create!(
      :title => "Title",
      :headline => "Headline",
      :description => "MyText",
      :type => "Type",
      :phone => "Phone",
      :address1 => "Address1",
      :address2 => "Address2",
      :city => "City",
      :state => "State",
      :latitude => "9.99",
      :longitude => "9.99",
      :url => "Url",
      :logo_url => "Logo Url",
      :summary => "MyText",
      :attractions => "MyText",
      :photo_urls => "MyText",
      :opening_date => "Opening Date",
      :number_of_rooms => "Number Of Rooms",
      :theme => "Theme",
      :total_gaming_space => "Total Gaming Space",
      :permanent_space => "Permanent Space",
      :casino_type => "Casino Type",
      :owner => "Owner"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/Headline/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Type/)
    expect(rendered).to match(/Phone/)
    expect(rendered).to match(/Address1/)
    expect(rendered).to match(/Address2/)
    expect(rendered).to match(/City/)
    expect(rendered).to match(/State/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/Url/)
    expect(rendered).to match(/Logo Url/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Opening Date/)
    expect(rendered).to match(/Number Of Rooms/)
    expect(rendered).to match(/Theme/)
    expect(rendered).to match(/Total Gaming Space/)
    expect(rendered).to match(/Permanent Space/)
    expect(rendered).to match(/Casino Type/)
    expect(rendered).to match(/Owner/)
  end
end
