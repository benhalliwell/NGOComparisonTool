require 'rails_helper'
describe "seeing a list of charities when filters are empty" do

  scenario "I can see charity information" do
    charities = FactoryGirl.create_list(:scotland, 2)
    visit "/"
    click_link ('MyString1')
    expect(page).to have_content (charities.first.purposes)
  end

  scenario "I can see a list of charities for scotland at root" do
    charities = FactoryGirl.create_list(:scotland, 20)
    visit "/"
    expect(page).to have_content(charities.first.charity_number)
    expect(page).to have_content(charities.last.charity_number)

    expect(page).to have_content(charities.first.charity_name)
    expect(page).to have_content(charities.last.charity_name)
  end

  scenario "I can see pagination if the list is over 20 items long at root" do
    charities = FactoryGirl.create_list(:scotland, 21)
    visit "/"
    expect(page).to have_content(charities.first.charity_number)
    expect(page).to have_content(charities.first.charity_name)
    #    Expect page to have pagination, so there should be no final record
    expect(page).to have_no_content(charities.last.charity_number)
    expect(page).to have_no_content(charities.last.charity_name)
    #    click next page on pagination
    click_link('Next')
    #    now should see last button
    expect(page).to have_content(charities.last.charity_number)
    expect(page).to have_content(charities.last.charity_name)
  end

  scenario "I can compare charities and see how they are preforming in different catagories" do
    charities = FactoryGirl.create_list(:scotland, 10)
    visit "/"
    # adding 10 charities for comparison
    all('Add To Comparison').map(&:click)
    click_button ('Compare')
    # user is able to select one of the below features they would like to compare
    expect(page).to have_content ("Expenditure")
    expect(page).to have_content ("Income")
    expect(page).to have_content ("Headquarters Locations")
    expect(page).to have_content ("Operating Location")
  end

  scenario "I can compare charities and see how they are preforming in different catagories" do
    charities = FactoryGirl.create_list(:scotland, 30)
    visit "/"
    # adding 10 charities for comparison
    all('Add To Comparison').map(&:click)
    click_link('Next')
    all('Add To Comparison').map(&:click)
    click_button ('Compare')
    # user is able to select one of the below features they would like to compare
    expect(page).to have_content ("Headquarters Locations")
  end

  scenario "I can compare all charities and see how they are preforming in different catagories" do
    charities = FactoryGirl.create_list(:scotland, 30)
    visit "/"
    # adding 10 charities for comparison
    all('Add To Comparison').map(&:click)
    click_link('Next')
    all('Add To Comparison').map(&:click)
    click_button ('Compare All')
    # user is able to select one of the below features they would like to compare
    expect(page).to have_content ("Headquarters Locations")
  end

  scenario "I can download the charities data that is being compared" do
    charities = FactoryGirl.create_list(:scotland, 10)
    visit "/"
    # adding 10 charities for comparison
    all('Add To Comparison').map(&:click)
    click_button ('Compare')
    # user is able to select one of the below features they would like to compare
    click_link 'Export Data (CSV)'
    expect(page).to have_content ("status")
  end

  specify "I can download the filtered list of scotland" do
    visit"/scotsfilter"
    click_link('Export filtered (CSV)')
    # when the download button is pressed the filtered list is internally shown
    expect(page).to have_content "charity_id"
  end
    specify "I can see tabs of each commision, so can change to other charity comissions" do
    visit"/"
    click_link ('Northern Ireland')
    click_link ('England')
    click_link ('Scotland')
    expect(page).to have_content "Northern Ireland"
    expect(page).to have_content "England"
    expect(page).to have_content "Scotland"
  end
end