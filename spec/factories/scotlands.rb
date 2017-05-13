FactoryGirl.define do
  factory :scotland do
    sequence(:id) {|n| n} 
    sequence(:charity_number){|n| "MyString#{n} "}
    sequence(:charity_name){|n| "MyString#{n} "}
    registered_date "MyString"
    known_as "MyString"
    charity_status "MyString"
    postcode "MyString"
    constitutional_form "MyString"
    previous_constitutional_form_1 "MyString"
    geographical_spread "MyString"
    main_operating_location "MyString"
    sequence(:purposes){|n| "MyString#{n}"}
    sequence(:beneficiaries){|n| "MyString#{n}"}
    activities "MyString"
    objectives "MyString"
    principal_office_trustees_address "MyString"
    website "MyString"
    sequence(:most_recent_year_income){|n| n}
    sequence(:most_recent_year_expenditure){|n| n}
    mailing_cycle "MyString"
    year_end "MyString"
    parent_charity_name "MyString"
    parent_charity_number "MyString"
    parent_charity_country_of_registration "MyString"
    designated_religious_body "MyString"
    regulatory_type "MyString"
  end
end
