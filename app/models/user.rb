require 'digest/sha1'

class User < ActiveRecord::Base

  acts_as_authentic
  
  attr_protected :admin

	def to_s
		name
	end

  def name
    "#{firstname} #{lastname}"
  end

end