# == Schema Information
#
# Table name: england_news
#
#  id         :integer          not null, primary key
#  charity_id :integer
#  regno      :integer
#  subno      :integer
#  name       :string
#  orgtype    :string
#  gd         :string
#  aob        :string
#  nhs        :string
#  ha_no      :string
#  corr       :string
#  add1       :string
#  add2       :string
#  add3       :string
#  add4       :string
#  add5       :string
#  postcode   :string
#  phone      :string
#  fax        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  fystart    :datetime
#  fyend      :datetime
#  income     :integer
#  expend     :integer
#  latitude   :float
#  longitude  :float
#

class EnglandNew < ApplicationRecord
  geocoded_by :postcode
  after_validation :geocode
  filterrific(
default_filter_params: {fystart: "2016/01/01 00:00:00 +0100".to_datetime},
available_filters: [
  :id,
  :regno,
  :subno,
  :charity_name,
  :postcode,
  :income_g,
  :income_l,
  :expend_g,
  :expend_l,
  :fystart,
  :fyend,
  :postcode,
  :expenditure_range,
  :income_range,
  :ngos900
]
)
scope :regno, lambda { |charity_number|
  where('england_news.regno = ? AND england_news.fystart LIKE ?', charity_number, "2015%")
}
scope :fystart, lambda { |fy|
  where('england_news.fystart LIKE ?', "2015%")
}
scope :income_g, lambda {|income|
  where('england_news.income >= ? AND england_news.fystart LIKE ?', income, "2015%")
}
scope :income_l, lambda {|income|
  where('england_news.income <= ? AND england_news.fystart LIKE ?', income, "2015%")
}
scope :expend_g, lambda {|expenditure|
  where('england_news.expend >= ? AND england_news.fystart LIKE ?', expenditure, "2015%")
}
scope :expend_l, lambda {|expenditure|
  where('england_news.expend <= ? AND england_news.fystart LIKE ?', expenditure, "2015%")
}
scope :charity_name, lambda {|name|
  where('england_news.name ILIKE ? AND england_news.fystart LIKE ?', "%"+name+"%", "2015%")
}
scope :ngos900, -> (england_news) do
  joins("INNER JOIN laura_filters ON england_news.name = laura_filters.name")
end
scope :postcode, lambda {|input|
return nil  if input[:postcode_d].blank?
# condition query, parse into individual keywords
terms = EnglandNew.near(input[:postcode_d], input[:max_range])
#Change here to make it an and/or query
where(
  terms.map { |term|
    " (id = ? AND england_news.fystart LIKE '2015%')"
  }.join(' OR '),
  *terms.map {|e|(e.id)}.flatten,
)
  }
  scope :income_range, lambda { |input|
    return nil if input.eql?("Select Income Range")
    clean_input = input.tr('£', '')
    cleaner_input = clean_input.tr(',', '')
    terms = cleaner_input.split(' ')
    if terms[0].eql?("More")
      where("england_news.income > ? AND england_news.fystart LIKE ?", terms[2], "2015%")  
    else
      where("england_news.income > ? AND england_news.income <? AND england_news.fystart LIKE ?", terms[0],terms[2],"2015%")
    end
    }
  scope :expenditure_range, lambda { |input|
    return nil if input.eql?("Select Expenditure Range")
    clean_input = input.tr('£', '')
    cleaner_input = clean_input.tr(',', '')
    terms = cleaner_input.split(' ')
    if terms[0].eql?("More")
      where("england_news.expend > ?AND england_news.fystart LIKE ?", terms[2],"2015%")  
    else
      where("england_news.expend > ? AND england_news.expend <?AND england_news.fystart LIKE ?", terms[0],terms[2],"2015%")
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
