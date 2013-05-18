class User < ActiveRecord::Base
  attr_accessible :name, :password, :rank_id, :password_confirmation
  belongs_to :rank
  has_many :articles
  validates_presence_of :name, :message => "can't be null"
  validates_length_of :name, :minimum => 4, :message => "must above length 4"
  validates_uniqueness_of :name,  :case_sensitive => true, :message => "has been already exit"
  validates_length_of :password, :minimum => 6, :message => "must above length 6"
  validates_presence_of :password, :message => "can't be null"
  validates_presence_of :rank_id
  validates_confirmation_of :password,  :message => "confirm password is not the same"
end
