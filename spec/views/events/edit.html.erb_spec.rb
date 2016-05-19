require 'rails_helper'

RSpec.describe "events/edit", type: :view do
  before(:each) do
    @event = assign(:event, Event.create!(
      :user_id => 1,
      :venue_id => 1,
      :parent_event_id => 1,
      :title => "MyString",
      :description => "MyText",
      :address1 => "MyString",
      :address2 => "MyString",
      :city => "MyString",
      :state => "MyString",
      :zipcode => "MyString",
      :country => "MyString",
      :locality_id => 1,
      :latitude => "9.99",
      :longitude => "9.99"
    ))
  end

  it "renders the edit event form" do
    render

    assert_select "form[action=?][method=?]", event_path(@event), "post" do

      assert_select "input#event_user_id[name=?]", "event[user_id]"

      assert_select "input#event_venue_id[name=?]", "event[venue_id]"

      assert_select "input#event_parent_event_id[name=?]", "event[parent_event_id]"

      assert_select "input#event_title[name=?]", "event[title]"

      assert_select "textarea#event_description[name=?]", "event[description]"

      assert_select "input#event_address1[name=?]", "event[address1]"

      assert_select "input#event_address2[name=?]", "event[address2]"

      assert_select "input#event_city[name=?]", "event[city]"

      assert_select "input#event_state[name=?]", "event[state]"

      assert_select "input#event_zipcode[name=?]", "event[zipcode]"

      assert_select "input#event_country[name=?]", "event[country]"

      assert_select "input#event_locality_id[name=?]", "event[locality_id]"

      assert_select "input#event_latitude[name=?]", "event[latitude]"

      assert_select "input#event_longitude[name=?]", "event[longitude]"
    end
  end
end
