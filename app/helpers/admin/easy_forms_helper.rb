module Admin::EasyFormsHelper

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
        html = "<tr><td>&nbsp;</td><td>#{field_html} #{label_html} #{error_html}</td></tr>"
      else
        html = "<tr><td>#{label_html}</td><td>#{field_html} #{error_html}</td></tr>"
    end
    content_tag('div',html, :class => (field_has_error?(model,method) ? 'withError' : nil))
  end

end