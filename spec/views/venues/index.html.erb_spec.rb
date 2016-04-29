require 'rails_helper'

RSpec.describe "venues/index", type: :view do
  before(:each) do
    assign(:venues, [
      Venue.create!(
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
      ),
      Venue.create!(
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
      )
    ])
  end

  it "renders a list of venues" do
    render
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "Headline".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Type".to_s, :count => 2
    assert_select "tr>td", :text => "Phone".to_s, :count => 2
    assert_select "tr>td", :text => "Address1".to_s, :count => 2
    assert_select "tr>td", :text => "Address2".to_s, :count => 2
    assert_select "tr>td", :text => "City".to_s, :count => 2
    assert_select "tr>td", :text => "State".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "Url".to_s, :count => 2
    assert_select "tr>td", :text => "Logo Url".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Opening Date".to_s, :count => 2
    assert_select "tr>td", :text => "Number Of Rooms".to_s, :count => 2
    assert_select "tr>td", :text => "Theme".to_s, :count => 2
    assert_select "tr>td", :text => "Total Gaming Space".to_s, :count => 2
    assert_select "tr>td", :text => "Permanent Space".to_s, :count => 2
    assert_select "tr>td", :text => "Casino Type".to_s, :count => 2
    assert_select "tr>td", :text => "Owner".to_s, :count => 2
  end
end
