require 'rails_helper'

RSpec.describe "venues/edit", type: :view do
  before(:each) do
    @venue = assign(:venue, Venue.create!(
      :title => "MyString",
      :headline => "MyString",
      :description => "MyText",
      :type => "",
      :phone => "MyString",
      :address1 => "MyString",
      :address2 => "MyString",
      :city => "MyString",
      :state => "MyString",
      :latitude => "9.99",
      :longitude => "9.99",
      :url => "MyString",
      :logo_url => "MyString",
      :summary => "MyText",
      :attractions => "MyText",
      :photo_urls => "MyText",
      :opening_date => "MyString",
      :number_of_rooms => "MyString",
      :theme => "MyString",
      :total_gaming_space => "MyString",
      :permanent_space => "MyString",
      :casino_type => "MyString",
      :owner => "MyString"
    ))
  end

  it "renders the edit venue form" do
    render

    assert_select "form[action=?][method=?]", venue_path(@venue), "post" do

      assert_select "input#venue_title[name=?]", "venue[title]"

      assert_select "input#venue_headline[name=?]", "venue[headline]"

      assert_select "textarea#venue_description[name=?]", "venue[description]"

      assert_select "input#venue_type[name=?]", "venue[type]"

      assert_select "input#venue_phone[name=?]", "venue[phone]"

      assert_select "input#venue_address1[name=?]", "venue[address1]"

      assert_select "input#venue_address2[name=?]", "venue[address2]"

      assert_select "input#venue_city[name=?]", "venue[city]"

      assert_select "input#venue_state[name=?]", "venue[state]"

      assert_select "input#venue_latitude[name=?]", "venue[latitude]"

      assert_select "input#venue_longitude[name=?]", "venue[longitude]"

      assert_select "input#venue_url[name=?]", "venue[url]"

      assert_select "input#venue_logo_url[name=?]", "venue[logo_url]"

      assert_select "textarea#venue_summary[name=?]", "venue[summary]"

      assert_select "textarea#venue_attractions[name=?]", "venue[attractions]"

      assert_select "textarea#venue_photo_urls[name=?]", "venue[photo_urls]"

      assert_select "input#venue_opening_date[name=?]", "venue[opening_date]"

      assert_select "input#venue_number_of_rooms[name=?]", "venue[number_of_rooms]"

      assert_select "input#venue_theme[name=?]", "venue[theme]"

      assert_select "input#venue_total_gaming_space[name=?]", "venue[total_gaming_space]"

      assert_select "input#venue_permanent_space[name=?]", "venue[permanent_space]"

      assert_select "input#venue_casino_type[name=?]", "venue[casino_type]"

      assert_select "input#venue_owner[name=?]", "venue[owner]"
    end
  end
end
