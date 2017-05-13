class CreateLauraFilters < ActiveRecord::Migration[5.0]
  def change
    create_table :laura_filters do |t|
      t.integer :charity_number
      t.integer :subno
      t.string :name

      t.timestamps
    end
  end
end
