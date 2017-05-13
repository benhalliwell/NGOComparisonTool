class CreateEnglandNews < ActiveRecord::Migration[5.0]
  def change
    create_table :england_news do |t|
      t.integer :charity_id
      t.integer :regno
      t.integer :subno
      t.string :name
      t.string :orgtype
      t.string :gd
      t.string :aob
      t.string :nhs
      t.string :ha_no
      t.string :corr
      t.string :add1
      t.string :add2
      t.string :add3
      t.string :add4
      t.string :add5
      t.string :postcode
      t.string :phone
      t.string :fax
      t.datetime :created_at
      t.datetime :updated_at
      t.datetime :fystart
      t.datetime :fyend
      t.integer :income
      t.integer :expend
      t.float   :latitude
      t.float   :longitude

      t.timestamps
    end
  end
end
