class Flag < ActiveRecord::Base
  attr_accessible :name
  has_many :articles
  validates_uniqueness_of :name
end
