FactoryGirl.define do
  factory :event do
    user_id 1
    venue_id 1
    parent_event_id 1
    title "MyString"
    description "MyText"
    start_date "2016-05-19 11:42:29"
    end_date "2016-05-19 11:42:29"
    address1 "MyString"
    address2 "MyString"
    city "MyString"
    state "MyString"
    zipcode "MyString"
    country "MyString"
    locality_id 1
    latitude "9.99"
    longitude "9.99"
  end
end
