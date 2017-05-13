class CreateScotlands < ActiveRecord::Migration[5.0]
  def change
    create_table :scotlands do |t|
      t.integer :Charity_id
      t.string :Charity_Number
      t.string :Charity_Name
      t.string :Registered_Date
      t.string :Known_As
      t.string :Charity_Status
      t.string :Postcode
      t.string :Constitutional_Form
      t.string :Previous_Constitutional_Form_1
      t.string :Geographical_Spread
      t.string :Main_Operating_Location
      t.string :Purposes
      t.string :Beneficiaries
      t.string :Activities
      t.string :Objectives
      t.string :Principal_Office_Trustees_Address
      t.string :Website
      t.string :Most_recent_year_income
      t.string :Most_recent_year_expenditure
      t.string :Mailing_cycle
      t.string :Year_end
      t.string :Parent_charity_name
      t.string :Parent_charity_number
      t.string :Parent_charity_country_of_registration
      t.string :Designated_religious_body
      t.string :Regulatory_type

      t.timestamps
      t.float :latitude
      t.float :longtitude
      t.float :lat
      t.float :lon
    end
  end
end
