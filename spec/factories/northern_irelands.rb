FactoryGirl.define do
  factory :northern_ireland do
    sequence(:reg_charity_number){|n| n} 
    sub_charity_number 1
    sequence(:charity_name) {|n| "MyString#{n}" } 
    date_registered "MyString"
    status "MyString"
    date_for_financial_year_ending "2017-03-22"
    total_income 1
    total_spending 1
    charitable_spending 1
    income_generation_and_governance 1
    public_address "MyString"
    website "MyString"
    email "MyString"
    telephone "MyString"
    company_number 1
    what_the_charity_does "MyString"
    who_the_charity_helps "MyString"
    how_the_charity_works "MyString"
  end
end
