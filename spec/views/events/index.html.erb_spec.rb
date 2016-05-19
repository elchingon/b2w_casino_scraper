require 'rails_helper'

RSpec.describe "events/index", type: :view do
  before(:each) do
    assign(:events, [
      Event.create!(
        :user_id => 1,
        :venue_id => 2,
        :parent_event_id => 3,
        :title => "Title",
        :description => "MyText",
        :address1 => "Address1",
        :address2 => "Address2",
        :city => "City",
        :state => "State",
        :zipcode => "Zipcode",
        :country => "Country",
        :locality_id => 4,
        :latitude => "9.99",
        :longitude => "9.99"
      ),
      Event.create!(
        :user_id => 1,
        :venue_id => 2,
        :parent_event_id => 3,
        :title => "Title",
        :description => "MyText",
        :address1 => "Address1",
        :address2 => "Address2",
        :city => "City",
        :state => "State",
        :zipcode => "Zipcode",
        :country => "Country",
        :locality_id => 4,
        :latitude => "9.99",
        :longitude => "9.99"
      )
    ])
  end

  it "renders a list of events" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Address1".to_s, :count => 2
    assert_select "tr>td", :text => "Address2".to_s, :count => 2
    assert_select "tr>td", :text => "City".to_s, :count => 2
    assert_select "tr>td", :text => "State".to_s, :count => 2
    assert_select "tr>td", :text => "Zipcode".to_s, :count => 2
    assert_select "tr>td", :text => "Country".to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
  end
end
