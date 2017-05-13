# == Schema Information
#
# Table name: northern_irelands
#
#  charity_id                       :integer          not null, primary key
#  reg_charity_number               :string
#  sub_charity_number               :string
#  charity_name                     :string
#  date_registered                  :string
#  status                           :string
#  date_for_financial_year_ending   :string
#  total_income                     :string
#  total_spending                   :string
#  charitable_spending              :string
#  income_generation_and_governance :string
#  retained                         :string
#  public_address                   :string
#  website                          :string
#  email                            :string
#  telephone                        :string
#  company_number                   :string
#  what_the_charity_does            :string
#  who_the_charity_helps            :string
#  how_the_charity_works            :string
#  created_at                       :datetime
#  updated_at                       :datetime
#  latitude                         :float
#  longitude                        :float
#

class NorthernIreland < ApplicationRecord
  geocoded_by :public_address
  after_validation :geocode
  filterrific(
    default_filter_params: { },
    available_filters: [
      :reg_charity_number,
      :total_income_g,
      :total_income_l,
      :total_spending_g,
      :total_spending_l,
      :what_the_charity_does,
      :who_the_charity_helps,
      :public_address,
      :charity_name,
      :income_range,
      :expenditure_range,
      :ngos900
    ]
  )
  scope :reg_charity_number, lambda {|charity_number|
     terms = charity_number.split(',')
#    terms = terms.map { |e|
#      ('%'+e.gsub('*', '%') + '%').gsub(/%+/, '%')
#    }
    where(
    terms.map { |term|
      "(northern_irelands.reg_charity_number) = ?"
    }.join(' OR '),
    *terms.map {|e| [e]}.flatten
  )
    }
  scope :total_income_g, lambda {|income|
    where('northern_irelands.total_income >= ?',income)
  }
  scope :total_income_l, lambda {|income|
    where('northern_irelands.total_income <= ?', income)
  }
   scope :total_spending_g, lambda {|spending|
    where('northern_irelands.total_spending >= ?',spending)
  }
  scope :total_spending_l, lambda {|spending|
    where('northern_irelands.total_spending <= ?', spending)
  }
  scope :charity_name, lambda {|name|
    where('northern_irelands.charity_name ILIKE ?', "%"+name+"%")
  }
  scope :ngos900, -> (northern_irelands) do
    joins("INNER JOIN laura_filters ON northern_irelands.charity_name = laura_filters.name")
  end
  scope :what_the_charity_does, lambda {|purposes|
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
      "(northern_irelands.what_the_charity_does) ILIKE ?"
    }.join(' AND '),
    *terms.map {|e| [e]}.flatten
  )
}
  scope :who_the_charity_helps, lambda {|benef|
  return nil  if benef.eql?("Select Beneficiaries")
  # condition query, parse into individual keywords
  terms = benef.downcase.split(/\s+/)

  # replace "*" with "%" for wildcard searches,
  # append '%', remove duplicate '%'s
  terms = terms.map { |e|
    ('%'+e.gsub('*', '%') + '%').gsub(/%+/, '%')
  }
  #Change here to make it an and/or query
  where(
    terms.map { |term|
      "(northern_irelands.who_the_charity_helps) ILIKE ?"
    }.join(' AND '),
    *terms.map {|e| [e]}.flatten
  )
    }
  scope :public_address, lambda {|input|
  return nil  if input[:pub_address].blank?
  # condition query, parse into individual keywords
  terms = NorthernIreland.near(input[:pub_address], input[:max_range])
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
      where("northern_irelands.total_income > ?", terms[2])  
    elsif terms[0].eql?("0")
      where("northern_irelands.total_income < ?", terms[2])  
    else
      where("northern_irelands.total_income > ? AND northern_irelands.total_income < ?", terms[0],terms[2])
    end
    }
    scope :expenditure_range, lambda { |input|
    return nil if input.eql?("Select Expenditure Range")
    clean_input = input.tr('£', '')
    cleaner_input = clean_input.tr(',', '')
    terms = cleaner_input.split(' ')
    if terms[0].eql?("More")
      where("northern_irelands.total_spending > ?", terms[2])  
    elsif terms[0].eql?("0")
      where("northern_irelands.total_spending < ?", terms[2])  
    else
      where("northern_irelands.total_spending > ? AND northern_irelands.total_spending < ?", terms[0],terms[2])
    end
    }
  
  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |result|
        csv << result.attributes.values_at(*column_names)
      end
    end
  end

end
