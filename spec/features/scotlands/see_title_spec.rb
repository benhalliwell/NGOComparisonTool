require 'rails_helper'

describe "seeing the title" do
  specify "I can see the title when at root as I am at scotland" do
    visit "/"
    expect(page).to have_content "NGO Comparison Tool"
  end
  specify "I can see the title when on scotlands filter page" do
  visit"/scotsfilter"
  expect(page).to have_content "NGO Comparison Tool"
  end
end
