class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  #for the form in index
  attr_accessor :custom
end
