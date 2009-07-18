module ApplicationHelper

	def asset_exists?(source)
    !rails_asset_id(source).blank?
  end

  def current_object
    controller.try(:object)
  end

  def partial(name, locals = {})
    locals = {:object => object || nil}.update(locals)
    render(:partial => name, :locals => locals)
  end

  # Override this helper from the file_column plugin
  def url_for_file_column(object_name, method, suffix=nil, object = nil)
    object = instance_variable_get("@#{object_name.to_s}") if object.nil?
    relative_path = object.send("#{method}_relative_path", suffix)
    return nil unless relative_path
    url = ""
    url << ActionController::Base.relative_url_root.to_s << "/"
    url << object.send("#{method}_options")[:base_url] << "/"
    url << relative_path
  end
  
  
  def uploaded_image(object, method, suffix=nil, options = {}, alternate_src = nil)
    return '' if object.nil?
    url = uploaded_file_url(object, method, suffix)
    options = {:alt => object.to_s}.update(options)
    if url
      image_tag(url, options)
    elsif alternate_src.nil?
      ''
    else
      image_tag(alternate_src, options)
    end
  end
  
  def uploaded_file_url(object, method, suffix=nil)
    return nil unless object.send(method,suffix) and File.exists?(object.send(method,suffix))
    relative_path = object.send("#{method}_relative_path", suffix)
    url = ''
    url << ActionController::Base.relative_url_root.to_s << "/"
    url << object.send("#{method}_options")[:base_url] << "/"
    url << relative_path
  end
    

	# Render a div for each flash giving it an id from its hash key e.g. "error" or "notice"
	def render_flash
		flash.to_a.map { |v| content_tag("div", v[1], "id" => v[0], "class" => "flash") }
	end

	def label(object,method,text = nil)
		method = method.id2name if method.is_a?(Symbol)
		content_tag "label", text ? text : method.humanize, :for => "#{object}_#{method}"
	end

	def field_has_error?(model, method)
    object = self.instance_variable_get("@#{model}")
		return object.errors.on(method) unless object.nil?
	end

	def class_if_error(model, method)
		field_has_error?(model, method) ? ' class="withError"' : ""
	end

	def error_message(model, method)
    object = instance_variable_get("@#{model}")
    if object and !object.errors.empty? 
      errors = instance_variable_get("@#{model}").errors.on(method)
      error = content_tag('span', (errors.is_a?(Array) ? errors.first : errors), :class => 'formError')
    end
    error ? "<br />#{error}" : ''
	end
	
  def format_date(date)
    return '' if date.nil?
    date.to_time.strftime("%B %d, %Y")
  end

  def odd_even
    @odd_even_state ||= 'even'
    @odd_even_state = @odd_even_state ==  'even' ? 'odd' : 'even'
  end


  def google_maps_javascript
    if GOOGLE_MAPS_KEY.is_a?(Hash)
      key = GOOGLE_MAPS_KEY[request.host]
    else
      key = GOOGLE_MAPS_KEY
    end
    %(<script src="http://maps.google.com/maps?file=api&v=2&key=#{key}" type="text/javascript"></script>)
  end

  def jquery
    %(<script src="/javascripts/jquery.js" type="text/javascript"></script>)
  end

  def jmaps
    %(<script src="/javascripts/jquery.jmap.js" type="text/javascript"></script>)
  end

  #
  # Write out the javascript and html to embed flash with SWFObject
  # A block can be supplied to capture alternative content for if flash isn't available
  #
  def embed_flash(swf_src, options = {}, params = {}, &block)
    options = {
      :width => 400,:height => 300,:version => "8",:background_color=>"#ffffff"
    }.update(options)
    if block_given?
      alternate_content = capture(&block)
    else
      alternate_content = ''
    end
    movie_name = swf_src.split('/').last.gsub(/\..+$/,'')
    content_div_id = "#{movie_name}_content"
    script = %(\n<script type="text/javascript">\n)
      script << %(var so = new SWFObject("#{swf_src}", "#{movie_name}", "#{options[:width]}", "#{options[:height]}", "#{options[:version]}", "#{options[:background_color]}");\n)
      params.each do |k,v|
        script << %(so.addVariable("#{k}", "#{v}");\n)
      end
  		script << %(so.write("#{content_div_id}");\n)
    script << "</script>"
    output = content_tag('div', alternate_content, :id => content_div_id) + script
    if block_given?
      concat(output, block.binding)
    else
      return output
    end
  end
  
end
