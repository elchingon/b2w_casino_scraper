require 'rails_helper'

RSpec.describe "events/show", type: :view do
  before(:each) do
    @event = assign(:event, Event.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Address1/)
    expect(rendered).to match(/Address2/)
    expect(rendered).to match(/City/)
    expect(rendered).to match(/State/)
    expect(rendered).to match(/Zipcode/)
    expect(rendered).to match(/Country/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/9.99/)
  end
end
