module BeforeAndAfter
  LEFT_SIDE_LATER  = 1
  RIGHT_SIDE_LATER = -1
  
  def before?(input_time)
    (self <=> input_time) == RIGHT_SIDE_LATER
  end
  
  def after?(input_time)
    (self <=> input_time) == LEFT_SIDE_LATER
  end
end

Time.send :include , BeforeAndAfter


class Array

  # Turn an array of arrays (key value pairs) into a hash
  def to_hash
    hash = {}
    self.each do |v|
      if v.is_a? Array and v.length == 2
        hash[v[0]] = v[1]
      end
    end
    hash
  end

end



# Loose the div around fields with errors
ActionView::Base.field_error_proc = lambda {|tag, _| tag}


class String
	# Return a string that can be used as part of a url
	def url_friendly
		self.downcase.gsub(/[^\-0-9a-z ]/, '').split.join('-')
	end
end


module Enumerable
	def random
		return self[rand(self.size)]
	end
end


# Nice to be able to have methods that accept either an active record object, or its id
# This makes it easy to make sure you've got the id before building some conditions
class ActiveRecord::Base
  def to_i
    id
  end
end


# So we get error messages wrapped in a span instead of a div which will tend to mess up forms
module ActionView::Helpers::ActiveRecordHelper  	

  def error_message_on(object, method, *args)
    options = args.extract_options!
    unless args.empty?
      ActiveSupport::Deprecation.warn('error_message_on takes an option hash instead of separate ' +
        'prepend_text, append_text, and css_class arguments', caller)

      options[:prepend_text] = args[0] || ''
      options[:append_text] = args[1] || ''
      options[:css_class] = args[2] || 'formError'
    end
    options.reverse_merge!(:prepend_text => '', :append_text => '', :css_class => 'formError')

    if (obj = (object.respond_to?(:errors) ? object : instance_variable_get("@#{object}"))) &&
      (errors = obj.errors.on(method))
      content_tag("span",
        "#{options[:prepend_text]}#{errors.is_a?(Array) ? errors.first : errors}#{options[:append_text]}",
        :class => options[:css_class]
      )
    else
      ''
    end
  end

end