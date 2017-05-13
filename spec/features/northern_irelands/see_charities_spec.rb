require 'rails_helper'
describe "seeing a list of charities when filters are empty" do
  specify "I can see the title when on northern_irelands filter page" do
    visit "/northern_irelandfilter"
    expect(page).to have_content "Comparison Tool"
  end

  specify "I can see tabs of each commision, so can change to other charity comissions" do
    visit"/northern_irelandfilter"
    click_link ('England')
    click_link ('Scotland')
    click_link ('Northern Ireland')
    expect(page).to have_content "Northern Ireland"
    expect(page).to have_content "England"
    expect(page).to have_content "Scotland"
  end
  scenario "I can see a list of charities for northern_ireland at northern irelands page" do
    charities = FactoryGirl.create_list(:northern_ireland, 20)
    visit "/northern_irelandfilter"
    expect(page).to have_content(charities.first.reg_charity_number)
    expect(page).to have_content(charities.last.reg_charity_number)
    
    expect(page).to have_content(charities.first.charity_name)
    expect(page).to have_content(charities.last.charity_name)
  end
  scenario "I can see pagination if the list is over 20 items long at northern irelands page" do
    charities = FactoryGirl.create_list(:northern_ireland, 21)
    visit "/northern_irelandfilter"
    expect(page).to have_content(charities.first.reg_charity_number)
    expect(page).to have_content(charities.first.charity_name)
#    Expect page to have pagination, so there should be no final record
    expect(page).to have_no_content(charities.last.reg_charity_number)
    expect(page).to have_no_content(charities.last.charity_name)
#    click next page on pagination
    click_link('Next')
#    now should see last button
    expect(page).to have_content(charities.last.reg_charity_number)
    expect(page).to have_content(charities.last.charity_name)    
  end

  scenario "I can see charity information" do
    charities = FactoryGirl.create_list(:northern_ireland, 2)
    visit "/northern_irelandfilter"
    click_link ('MyString')
    expect(page).to have_content (charities.first.charity_name)
  end
  scenario "I can compare charities and see how they are preforming in different catagories" do
    charities = FactoryGirl.create_list(:northern_ireland, 10)
    visit "/northern_irelandfilter"
    # adding 10 charities for comparison
    all('Add To Comparison').map(&:click)
    click_button ('Compare')
    # user is able to select one of the below features they would like to compare
    expect(page).to have_content ("Expenditure")
    expect(page).to have_content ("Income")
    expect(page).to have_content ("Headquarters Locations")
  end
  
  specify "I can download the filtered list of northern ireland" do
    visit"/northern_irelandfilter"
    click_link('Export filtered (CSV)')
    # when the download button is pressed the filtered list is internally shown
    expect(page).to have_content "charity_id"
  end
  scenario "I can compare charities and see how they are preforming in different catagories across pages" do
    charities = FactoryGirl.create_list(:northern_ireland, 30)
    visit "/northern_irelandfilter"
    # adding 10 charities for comparison
    all('Add To Comparison').map(&:click)
    click_link('Next')
    all('Add To Comparison').map(&:click)
    click_button ('Compare')
    # user is able to select one of the below features they would like to compare
    expect(page).to have_content ("Headquarters Locations")
  end
  

  scenario "I can download the charities data that is being compared" do
    charities = FactoryGirl.create_list(:northern_ireland, 10)
    visit "/northern_irelandfilter"
    # adding 10 charities for comparison
    all('Add To Comparison').map(&:click)
    click_button ('Compare')
    # user is able to select one of the below features they would like to compare
    click_link 'Download Data (CSV)'
    expect(page).to have_content ("status")
  end
  
end