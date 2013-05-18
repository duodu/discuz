class Rank < ActiveRecord::Base
  attr_accessible :name
  has_many :users
  validates_uniqueness_of :name
end
