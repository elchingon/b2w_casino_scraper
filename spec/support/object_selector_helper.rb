module ObjectSelectorHelpers
  def object_selector(obj)
    "##{dom_id(obj)}"
  end

  def user_sees_object object
    expect(page).to have_css object_selector(object)
  end

  def user_does_not_see_object object
    expect(page).to_not have_css object_selector(object)
  end
end

RSpec.configure do |config|
  config.include ActionView::RecordIdentifier, type: :feature
  config.include ObjectSelectorHelpers, type: :feature
end