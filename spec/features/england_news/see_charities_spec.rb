require 'rails_helper'
describe "seeing a list of charities when filters are empty" do

  scenario "I can see charity information" do
    charities = FactoryGirl.create_list(:england_news, 2)
    visit "/engfilter"
    expect(page).to have_content (charities.first.regno)
  end

  scenario "I can see a list of charities for england on englands page" do
    charities = (0..9).map {|n| FactoryGirl.create(:england_news, regno: 1) }
    visit "/engfilter"
    expect(page).to have_content(charities.first.regno)
    expect(page).to have_content(charities.last.regno)

    expect(page).to have_no_content(charities.first.name)
    expect(page).to have_no_content(charities.last.name)
  end


  scenario "I can see minimum number of checkboxes for each element in the table " do
    charities = FactoryGirl.create_list(:england_news, 17)
    visit "/engfilter"
    # expect(page).to have_content ("Add To Comparison")
    expect(page).to have_content ("Comparison")
  end

  scenario "I can compare charities and see how they are preforming in different catagories" do
    charities = FactoryGirl.create_list(:england_news, 10)
    visit "/engfilter"
    # adding 10 charities for comparison
    all('Add To Comparison').map(&:click)
    click_button ('Compare')
    # user is able to select one of the below features they would like to compare
    expect(page).to have_content ("Expenditure")
    expect(page).to have_content ("Income")
    expect(page).to have_content ("Headquarters Locations")
  end

  scenario "I can compare charities and see how they are preforming in different catagories" do
    charities = FactoryGirl.create_list(:england_news, 10)
    visit "/engfilter"
    # adding 10 charities for comparison
    all('Add To Comparison').map(&:click)
    click_button ('Compare')
    # user is able to select one of the below features they would like to compare
    expect(page).to have_content ("Headquarters Locations")
  end

  scenario "I can compare charities and see how they are preforming in different catagories" do
    charities = FactoryGirl.create_list(:england_news, 10)
    visit "/engfilter"
    # adding 10 charities for comparison
    all('Add To Comparison').map(&:click)
    click_button ('Compare All')
    # user is able to select one of the below features they would like to compare
    expect(page).to have_content ("Headquarters Locations")
  end

  scenario "I can download the filtered list of scotland" do
    visit"/engfilter"
    click_link('Export filtered (CSV)')
    # when the download button is pressed the filtered list is internally shown
    expect(page).to have_content "name"
  end

end
