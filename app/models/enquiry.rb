class Enquiry < ActiveRecord::Base
  
  validates_presence_of :name,:email
  validates_format_of :email, :with => Format::EMAIL, :message => 'Invalid'
  
end
