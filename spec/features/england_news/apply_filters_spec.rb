require 'rails_helper'
describe "applying filters to the england list" do
  scenario "I search for a specific charity number" do
     charities = (0..9).map {|n| FactoryGirl.create(:england_news, regno: 1) }
     visit "/engfilter"
     fill_in('Charity Number', :with => 1)
     click_button('Apply Filters')
     expect(page).to have_content(charities[1].regno)
     expect(page).to have_content(charities[4].regno)
     expect(page).to have_content(charities[5].regno)

  end
  scenario "i apply a minimum income filter" do
    charities = (0..9).map {|income| FactoryGirl.create(:england_news, income: income, name: "Name#{income}", regno: 1) }
    visit "/engfilter"
    fill_in('Minimum Income', :with => 1)
    click_button('Apply Filters')
    expect(page).to have_content(charities[1].regno)
    expect(page).to have_content(charities[5].regno)
    expect(page).to have_content(charities[6].regno)
  end

  scenario "i apply a maximum income filter" do
    charities = (0..9).map {|income| FactoryGirl.create(:england_news, income: income, name: "Name#{income}", regno: 1) }
    visit "/engfilter"
    fill_in('Maximum Income', :with => 1)
    click_button('Apply Filters')

    expect(page).to have_content(charities[1].regno)
    expect(page).to have_content(charities[5].regno)
    expect(page).to have_content(charities[6].regno)
  end

  scenario "i apply a maximum income and expenditure filter" do
    charities = (0..9).map {|income| FactoryGirl.create(:england_news, expend: income, income: income, name: "Name#{income}", regno: 1) }
    visit "/engfilter"
    fill_in('Maximum Income', :with => 1)
    fill_in('Maximum Expenditure', :with => 1)
    click_button('Apply Filters')

    expect(page).to have_content(charities[1].regno)
    expect(page).to have_content(charities[5].regno)
    expect(page).to have_content(charities[6].regno)
  end

  scenario "i apply a Minimum income and expenditure filter" do
    charities = (0..9).map {|income| FactoryGirl.create(:england_news, expend: income, income: income, name: "Name#{income}", regno: 1) }
    visit "/engfilter"
    fill_in('Minimum Income', :with => 1)
    fill_in('Minimum Expenditure', :with => 1)
    click_button('Apply Filters')

    expect(page).to have_content(charities[1].regno)
    expect(page).to have_content(charities[5].regno)
    expect(page).to have_content(charities[6].regno)
  end

  scenario "i apply a minimum expenditure filter" do
    charities = (0..9).map {|expen| FactoryGirl.create(:england_news, expend: expen,name: "Name#{expen}", regno: 1) }
    visit "/engfilter"
    fill_in('Minimum Expenditure', :with => 1)
    click_button('Apply Filters')
    expect(page).to have_content(charities[1].regno)
    expect(page).to have_content(charities[5].regno)
    expect(page).to have_content(charities[6].regno)
  end
  scenario "i apply a maximum expenditure filter" do
    charities = (0..9).map {|expen| FactoryGirl.create(:england_news, expend: expen,name: "Name#{expen}", regno: 1) }
    visit "/engfilter"
    fill_in('Maximum Expenditure', :with => 1)
    click_button('Apply Filters')
    expect(page).to have_content(charities[1].regno)
    expect(page).to have_content(charities[5].regno)
    expect(page).to have_content(charities[6].regno)
  end

  scenario "I apply HQ location filter" do
    charities = (0..9).map {|n| FactoryGirl.create(:england_news, postcode: "S1 3PB",name: "Name#{n}", regno: 1) }
    visit "/engfilter"
    expect(page).to have_content(charities.first.regno)
    expect(page).to have_content(charities.last.regno)
    fill_in('HQ Location', :with => 'S1 3PB')
    click_button('Apply Filters')
    expect(page).to have_content(charities[1].regno)
    expect(page).to have_content(charities[9].regno)
    expect(page).to have_content(charities[7].regno)
  end

  specify "I can download the filtered list of england" do
    visit"/engfilter"
    
    click_link('Export filtered (CSV)')
    # when the download button is pressed the filtered list is internally shown
    expect(page).to have_content "charity_id"
  end

end