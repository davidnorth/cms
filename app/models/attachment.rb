class Attachment < ActiveRecord::Base
  belongs_to :page
  belongs_to :attachable, :polymorphic => true
  
  validates_presence_of :page, :attachable
  validates_associated :attachable
  
  default_scope :order => 'position'
  named_scope :of_type, lambda {|t| {:conditions => {:attachable_type => t}} }

  acts_as_list :scope => :page
  
end
