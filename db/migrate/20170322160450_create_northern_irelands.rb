class CreateNorthernIrelands < ActiveRecord::Migration[5.0]
  def change
    create_table :northern_irelands do |t|
      t.integer :Charity_id
      t.integer :Reg_charity_number
      t.integer :Sub_charity_number
      t.string :Charity_name
      t.string :Date_registered
      t.string :Status
      t.date :Date_for_financial_year_ending
      t.integer :Total_income
      t.integer :Total_spending
      t.integer :Charitable_spending
      t.integer :Income_generation_and_governance
      t.string :Public_address
      t.string :Website
      t.string :Email
      t.string :Telephone
      t.integer :Company_number
      t.string :What_the_charity_does
      t.string :Who_the_charity_helps
      t.string :How_the_charity_works

      t.timestamps
      t.float :latitude
      t.float :longitude
    end
  end
end
