require 'rails_helper'

describe "seeing the title" do
  specify "I can see the title when on northern_irelands filter page" do
    visit "/northern_irelandfilter"
    expect(page).to have_content "NGO Comparison Tool"
  end
end
