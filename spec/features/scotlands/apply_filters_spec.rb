require 'rails_helper'


describe "applying filters to the scotland list" do

  scenario "i apply a minimum income filter" do
    charities = (0..9).map {|income| FactoryGirl.create(:scotland, most_recent_year_income: income, charity_name: "Name#{income}", charity_number: "#{income}") }
    visit "/scotsfilter"
    fill_in('Minimum Income', :with => 5)
    click_button('Apply Filters')
    expect(page).to have_no_content(charities[4].charity_name)
    expect(page).to have_content(charities[5].charity_name)
    expect(page).to have_content(charities[6].charity_name)
  end
  scenario "i apply a maximum income filter" do
    charities = (0..9).map {|income| FactoryGirl.create(:scotland, most_recent_year_income: income, charity_name: "Name#{income}", charity_number: "#{income}") }
    visit "/scotsfilter"
    fill_in('Maximum Income', :with => 5)
    click_button('Apply Filters')

    expect(page).to have_content(charities[4].charity_name)
    expect(page).to have_content(charities[5].charity_name)
    expect(page).to have_no_content(charities[6].charity_name)
  end


  scenario "i apply a maximum income and expenditure filter" do
    charities = (0..9).map {|income| FactoryGirl.create(:scotland, most_recent_year_income: income, charity_name: "Name#{income}", charity_number: "#{income}") }
    visit "/scotsfilter"
    fill_in('Maximum Income', :with => 5)
    fill_in('Minimum Expenditure', :with => 5)
    click_button('Apply Filters')
    expect(page).to have_content(charities[4].charity_name)
    expect(page).to have_content(charities[5].charity_name)
    expect(page).to have_no_content(charities[6].charity_name)
  end

  scenario "i apply a Minimum income and expenditure filter" do
    charities = (0..9).map {|income| FactoryGirl.create(:scotland, most_recent_year_income: income, charity_name: "Name#{income}", charity_number: "#{income}") }
    visit "/scotsfilter"
    fill_in('Minimum Income', :with => 5)
    fill_in('Minimum Expenditure', :with => 5)
    click_button('Apply Filters')
    expect(page).to have_no_content(charities[4].charity_name)
    expect(page).to have_content(charities[5].charity_name)
    expect(page).to have_content(charities[6].charity_name)
  end

  scenario "i apply a minimum expenditure filter" do
    charities = (0..9).map {|expen| FactoryGirl.create(:scotland, most_recent_year_expenditure: expen,charity_name: "Name#{expen}", charity_number: "#{expen}") }
    visit "/scotsfilter"
    fill_in('Minimum Expenditure', :with => 5)
    click_button('Apply Filters')
    expect(page).to have_no_content(charities[4].charity_name)
    expect(page).to have_content(charities[5].charity_name)
    expect(page).to have_content(charities[6].charity_name)
  end
  scenario "i apply a maximum expenditure filter" do
    charities = (0..9).map {|expen| FactoryGirl.create(:scotland, most_recent_year_expenditure: expen,charity_name: "Name#{expen}", charity_number: "#{expen}") }
    visit "/scotsfilter"
    fill_in('Maximum Expenditure', :with => 5)
    click_button('Apply Filters')
    expect(page).to have_content(charities[4].charity_name)
    expect(page).to have_content(charities[5].charity_name)
    expect(page).to have_no_content(charities[6].charity_name)
  end
  scenario "I apply a purposes filter" do
    charities = (0..9).map {|n| FactoryGirl.create(:scotland, purposes: "purpose#{n}",charity_name: "Name#{n}", charity_number: "#{n}") }
    visit "/scotsfilter"
    expect(page).to have_content(charities.first.charity_name)
    expect(page).to have_content(charities.last.charity_name)
    fill_in('Purpose', :with => 'purpose8')
    click_button('Apply Filters')
    expect(page).to have_no_content(charities[8].charity_name)
    expect(page).to have_no_content(charities[9].charity_name)
    expect(page).to have_no_content(charities[7].charity_name)
  end
  scenario "I apply a beneficiaries filter" do
    charities = (0..9).map {|n| FactoryGirl.create(:scotland, beneficiaries: "beneficiary#{n}",charity_name: "Name#{n}", charity_number: "#{n}") }
    visit "/scotsfilter"
    expect(page).to have_content(charities.first.charity_name)
    expect(page).to have_content(charities.last.charity_name)
    fill_in('Purpose', :with => 'purpose8')
    click_button('Apply Filters')
    expect(page).to have_content(charities[8].charity_name)
  end

  scenario "I apply HQ location filter" do
    charities = (0..9).map {|n| FactoryGirl.create(:scotland, postcode: "S1 3PB",charity_name: "Name#{n}", charity_number: "#{n}") }
    visit "/scotsfilter"
    expect(page).to have_content(charities.first.charity_name)
    expect(page).to have_content(charities.last.charity_name)
    fill_in('HQ Location', :with => 'S1 3PB')
    click_button('Apply Filters')
    expect(page).to have_content(charities[1].charity_number)
    expect(page).to have_content(charities[9].charity_name)
    expect(page).to have_content(charities[7].charity_name)
  end

  scenario "I apply Operation Location filter" do
    charities = (0..9).map {|n| FactoryGirl.create(:scotland, postcode: "S1 3PB",charity_name: "Name#{n}", charity_number: "#{n}") }
    visit "/scotsfilter"
    expect(page).to have_content(charities.first.charity_name)
    expect(page).to have_content(charities.last.charity_name)
    fill_in('Operation Location', :with => 'S1 3PB')
    click_button('Apply Filters')
    expect(page).to have_content(charities[1].charity_number)
    expect(page).to have_content(charities[9].charity_name)
    expect(page).to have_content(charities[7].charity_name)
  end

end