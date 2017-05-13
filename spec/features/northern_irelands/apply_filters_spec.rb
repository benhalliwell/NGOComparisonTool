require 'rails_helper'
describe "applying filters to the northern ireland list" do
  scenario "i apply a minimum income filter" do
    charities = (0..9).map {|income| FactoryGirl.create(:northern_ireland, total_income: income, charity_name: "Name#{income}", reg_charity_number: "#{income}") }
    visit "/northern_irelandfilter"
    fill_in('Minimum Income', :with => 5)
    click_button('Apply Filters')
    expect(page).to have_no_content(charities[4].charity_name)
    expect(page).to have_content(charities[5].charity_name)
    expect(page).to have_content(charities[6].charity_name)
  end

  scenario "i apply a maximum income filter" do
    charities = (0..9).map {|income| FactoryGirl.create(:northern_ireland, total_income: income, charity_name: "Name#{income}", reg_charity_number: "#{income}") }
    visit "/northern_irelandfilter"
    fill_in('Maximum Income', :with => 5)
    click_button('Apply Filters')
    expect(page).to have_content(charities[4].charity_name)
    expect(page).to have_content(charities[5].charity_name)
    expect(page).to have_no_content(charities[6].charity_name)
  end

  scenario "i apply a maximum income and maximum expenditure filter" do
    charities = (0..9).map {|income| FactoryGirl.create(:northern_ireland,total_spending: income, total_income: income, charity_name: "Name#{income}", reg_charity_number: "#{income}") }
    visit "/northern_irelandfilter"
    fill_in('Maximum Income', :with => 1)
    fill_in('Maximum Expenditure', :with => 1)
    click_button('Apply Filters')
    expect(page).to have_content(charities[1].reg_charity_number)
    expect(page).to have_no_content(charities[5].charity_name)
    expect(page).to have_no_content(charities[6].charity_name)
  end

  scenario "i apply a minimum expenditure filter" do
    charities = (0..9).map {|expen| FactoryGirl.create(:northern_ireland, total_spending: expen, charity_name: "Name#{expen}", reg_charity_number: "#{expen}") }
    visit "/northern_irelandfilter"
    fill_in('Minimum Expenditure', :with => 5)
    click_button('Apply Filters')
    expect(page).to have_no_content(charities[4].charity_name)
    expect(page).to have_content(charities[5].charity_name)
    expect(page).to have_content(charities[6].charity_name)
  end
  scenario "i apply a maximum expenditure filter" do
    charities = (0..9).map {|expen| FactoryGirl.create(:northern_ireland, total_spending: expen,charity_name: "Name#{expen}", reg_charity_number: "#{expen}") }
    visit "/northern_irelandfilter"
    fill_in('Maximum Expenditure', :with => 2)
    click_button('Apply Filters')

    expect(page).to have_content(charities[1].reg_charity_number)
    expect(page).to have_no_content(charities[5].charity_name)
    expect(page).to have_no_content(charities[6].charity_name)
  end
  scenario "I apply a purposes filter" do
    charities = (0..9).map {|n| FactoryGirl.create(:northern_ireland, what_the_charity_does: "purpose#{n}",charity_name: "Name#{n}", reg_charity_number: "#{n}") }
    visit "/northern_irelandfilter"
    expect(page).to have_no_content(charities.first.charity_name)
    expect(page).to have_no_content(charities.last.charity_name)
    fill_in('Purpose', :with => 'purpose1')
    click_button('Apply Filters')
    expect(page).to have_no_content(charities[8].charity_name)
    expect(page).to have_no_content(charities[9].charity_name)
    expect(page).to have_no_content(charities[7].charity_name)
  end
  scenario "I apply a beneficiaries filter" do
    charities = (0..9).map {|n| FactoryGirl.create(:northern_ireland, who_the_charity_helps: "beneficiary#{n}",charity_name: "Name#{n}", reg_charity_number: "#{n}") }
    visit "/northern_irelandfilter"
    expect(page).to have_no_content(charities.first.charity_name)
  end
end