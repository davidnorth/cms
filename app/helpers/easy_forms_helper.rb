module EasyFormsHelper

  def field(model, method, options = {})
    default_options = { :helper => :text_field, :helper_args => [], :label => "#{method.to_s.humanize}:", :helper_options =>  {} }
    if method.to_s == 'password'
      default_options[:helper] = :password_field
    end
    options = default_options.update(options)
    helper_options = {:class => options[:helper].to_s}.update(options[:helper_options])
    helper_args = options[:helper_args] << helper_options
    label_html = label(model, method, options[:label])
    field_html = send(options[:helper], model, method, *helper_args)
    error_html = error_message_on(model, method).to_s
    if options[:helper] == :check_box
      html = "#{field_html} #{label_html} #{error_html}"
    else
      html = "#{label_html}<br />#{field_html} #{error_html}"
    end
    content_tag('p', html, :class => (field_has_error?(model,method) ? 'withError' : nil))
  end

  # Render a collection of radio buttons with labels using the radio_button helper to build the input tag
  # Supply values as an array of strings or a hash of value=>label pairs
  def radio_buttons(model, method, values, options = {})
    values = values.is_a?(Hash) ? values.to_a : values.map{|v| [v,v]}
    radios = values.map do |value|
      html = radio_button(model, method, value[0].to_s)
      html << '&nbsp; ' << value[1].to_s
      content_tag('label', html)
    end
    radios.join(' &nbsp; ')
  end

  def simple_collection_select(model,association_method, options = {}, html_options = {})
    klass = eval(model.to_s.camelize)
    association_reflection = klass.reflect_on_association(association_method)
    if association_reflection.nil?
      raise "Association #{association_method} not found in class #{klass.to_s}"
    end
    association_class = eval(association_reflection.class_name)
    collection_select(model, association_reflection.primary_key_name, association_class.all, :id, :to_s, options, html_options)
  end

end