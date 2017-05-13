# == Schema Information
#
# Table name: scotlands
#
#  charity_id                             :integer          not null, primary key
#  charity_number                         :string
#  charity_name                           :string
#  registered_date                        :string
#  known_as                               :string
#  charity_status                         :string
#  postcode                               :string
#  constitutional_form                    :string
#  previous_constitutional_form_1         :string
#  geographical_spread                    :string
#  main_operating_location                :string
#  purposes                               :string
#  beneficiaries                          :string
#  activities                             :string
#  objectives                             :string
#  principal_office_trustees_address      :string
#  website                                :string
#  most_recent_year_income                :integer
#  most_recent_year_expenditure           :integer
#  mailing_cycle                          :string
#  year_end                               :string
#  parent_charity_name                    :string
#  parent_charity_number                  :string
#  parent_charity_country_of_registration :string
#  designated_religious_body              :string
#  regulatory_type                        :string
#  created_at                             :decimal(, )      not null
#  updated_at                             :datetime         not null
#  latitude                               :float
#  longitude                              :float
#  lat                                    :float
#  lon                                    :float
#

class Scotland < ApplicationRecord
#  accepts_nested_attributes_for :postcode
  #has_many :laura_filters
  geocoded_by :postcode
  geocoded_by :main_operating_location, :latitude=>:lat , :longitude => :lon
  after_validation :geocode
#
    filterrific(
  default_filter_params: { },
  available_filters: [
    :charity_number,
    :most_recent_year_income_g,
    :most_recent_year_income_l,
    :most_recent_year_expenditure_g,
    :most_recent_year_expenditure_l,
    :purposes,
    :beneficiaries,
    :postcode,
    :main_operating_location,
    :charity_name,
    :income_range,
    :expenditure_range,
    :ngos900
  ]
)
# define ActiveRecord scopes for
# :search_query, :sorted_by, :with_country_id, and :with_created_at_gte
  scope :charity_number, lambda { |charity_number|
    terms = charity_number.split(',')
#    terms = terms.map { |e|
#      ('%'+e.gsub('*', '%') + '%').gsub(/%+/, '%')
#    }
    where(
    terms.map { |term|
      "(scotlands.charity_number) = ?"
    }.join(' OR '),
    *terms.map {|e| [e]}.flatten
  )
  }
  scope :most_recent_year_income_g, lambda {|income|
    where('scotlands.most_recent_year_income >= ?',income)
  }
  scope :most_recent_year_income_l, lambda {|income|
    where('scotlands.most_recent_year_income <= ?', income)
  }
  scope :most_recent_year_expenditure_g, lambda {|expenditure|
    where('scotlands.most_recent_year_expenditure >= ?', expenditure)
  }
  scope :most_recent_year_expenditure_l, lambda {|expenditure|
    where('scotlands.most_recent_year_expenditure <= ?', expenditure)
  }
  scope :charity_name, lambda {|name|
    where('scotlands.charity_name ILIKE ?', "%"+name+"%")
  }
  scope :purposes, lambda {|purposes|
  return nil  if purposes.eql?("Select Purpose")
  # condition query, parse into individual keywords
  terms = purposes.downcase.split(/\s+/)

  # replace "*" with "%" for wildcard searches,
  # append '%', remove duplicate '%'s
  terms = terms.map { |e|
    ('%'+e.gsub('*', '%') + '%').gsub(/%+/, '%')
  }
  where(
    terms.map { |term|
      "(scotlands.purposes) ILIKE ?"
    }.join(' AND '),
    *terms.map {|e| [e]}.flatten
  )
}
  scope :beneficiaries, lambda {|benef|
  return nil  if benef.eql?("Select Beneficiaries")
  # condition query, parse into individual keywords
  format_benef=""
  if benef.eql?("The Elderly")
    format_benef = "Older People"
  elsif benef.eql?("The Disabled")
    format_benef= "disabilities"
  elsif benef.eql?("Youth")
    format_benef= "children"
  else
    format_benef = benef
  end

  terms = format_benef.downcase.split(/\s+/)

  # replace "*" with "%" for wildcard searches,
  # append '%', remove duplicate '%'s
  terms = terms.map { |e|
    ('%'+e.gsub('*', '%') + '%').gsub(/%+/, '%')
  }
  #Change here to make it an and/or query
  where(
    terms.map { |term|
      "(scotlands.beneficiaries) ILIKE ?"
    }.join(' AND '),
    *terms.map {|e| [e]}.flatten
  )
    }

scope :postcode, lambda {|input|
  return nil  if input[:postcode_d].blank?
  # condition query, parse into individual keywords
  terms = Scotland.near(input[:postcode_d], input[:max_range])
  #Change here to make it an and/or query
  where(
    terms.map { |term|
      " charity_id = ?"
    }.join(' OR '),
    *terms.map {|e|(e.charity_id)}.flatten
  )
    }
  scope :main_operating_location, lambda {|input|
  return nil  if input[:main].blank?
  # condition query, parse into individual keywords
  terms = Scotland.near(input[:main],input[:max_range])
  #Change here to make it an and/or query
  where(
    terms.map { |term|
      " charity_id = ?"
    }.join(' OR '),
    *terms.map {|e|(e.charity_id)}.flatten
  )
    }

  scope :income_range, lambda { |input|
    return nil if input.eql?("Select Income Range")
    clean_input = input.tr('£', '')
    cleaner_input = clean_input.tr(',', '')
    terms = cleaner_input.split(' ')
    if terms[0].eql?("More")
      where("scotlands.most_recent_year_income > ?", terms[2])
    else
      where("scotlands.most_recent_year_income > ? AND scotlands.most_recent_year_income <?", terms[0],terms[2])
    end
    }
  scope :expenditure_range, lambda { |input|
    return nil if input.eql?("Select Expenditure Range")
    clean_input = input.tr('£', '')
    cleaner_input = clean_input.tr(',', '')
    terms = cleaner_input.split(' ')
    if terms[0].eql?("More")
      where("scotlands.most_recent_year_expenditure > ?", terms[2])
    else
      where("scotlands.most_recent_year_expenditure > ? AND scotlands.most_recent_year_expenditure <?", terms[0],terms[2])
    end
    }

    scope :ngos900, -> (scotlands) do
      joins("INNER JOIN laura_filters ON scotlands.charity_name = laura_filters.name")
    end

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |result|
        csv << result.attributes.values_at(*column_names)
      end
    end
  end
end
