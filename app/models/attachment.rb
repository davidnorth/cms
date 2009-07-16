class Attachment < ActiveRecord::Base
  belongs_to :page
  belongs_to :attachable, :polymorphic => true
  
  validates_presence_of :page, :attachable
  
end
