module Public::BaseHelper
  
  def html_transform(text)
    #process_helpers(auto_link(TextileLite.new.process(text)))
    auto_link(textilize(text))
  end

  def process_helpers(text)
    text.gsub( /\{\{([^\}]+)\}\}/ ) do |match|
      method,*args = $1.split(':')
      respond_to?(method) ? send(method,*args) : ''
    end
  end

  def snippet(template_variable)
    snippet = Snippet.find_by_template_variable(template_variable.to_s)
    return '' if snippet.nil?
    case snippet.text_format
      when 'textile'
        html_transform(snippet.value)
      when 'text'
        h(snippet.value)
      else
        snippet.value
    end
  end

  def odd_even
    @odd_even_state ||= 'even'
    @odd_even_state = @odd_even_state ==  'even' ? 'odd' : 'even'
  end

  # If a URL starts with '/' assume its a URL within this site, otherwise add http:// if it doesn't start with a protocol
  def normalize_url(string)
    if string =~ /[a-z]+:\/\// or string =~ /\//
      string
    else
      "http://#{string}"
    end
  end
  
  def render_shared(template, locals = {})
    render(:partial => "public/shared/#{template}", :locals => locals)
  end

end
