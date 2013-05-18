class Article < ActiveRecord::Base
  attr_accessible :content, :flag_id, :title, :top_id, :user_id, :submit_date, :last_edit_date
  belongs_to :flag
  belongs_to :top, :class_name => "Article", :foreign_key => "top_id"
  belongs_to :user
  validates_presence_of :title, :message => "can't be null"
  validates_presence_of :content, :message => "can't be null"
  validates_presence_of :user_id, :message => "can't be null"
  validates_length_of :title, :minimum => 6, :message => "is too short"
  validates_length_of :content, :minimum => 10, :message => "is too short"
  validates_presence_of :submit_date, :last_edit_date
end
