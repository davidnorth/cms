module Admin::BaseHelper
  
  def link_to_with_icon(icon,text,url_options = false, link_options = {})
    icon = image_tag("/images/admin/#{icon}.gif")
    if url_options
      link_to("#{icon} #{text}", url_options, link_options)
    else
      content_tag('span', "#{icon} #{text}", :class => 'disabled')
    end
  end
  
  def icon(name)
    image_tag("/images/admin/icons/#{name}.png")
  end
  
  def button(text, options = {})
    options = {
      :class => 'positive'
    }.update(options)
    if icon_name = options.delete(:icon)
      text = icon(icon_name) + ' ' + text
    end
    content_tag('button', text, options)
  end
  
  def link_button(text, url, options = {})
    options = {
      :class => 'positive'
    }.update(options)
    options[:class] += ' button'
    if icon_name = options.delete(:icon)
      text = icon(icon_name) + ' ' + text
    end
    link_to(text, url, options)
  end

  # Make an admin tab that coveres one or more resources supplied by symbols
  # Option hash may follow. Only option currently is :label to ovveride link text
  # otherwise based on the first resource name
  def tab(*args)
    options = {:label => args.first.to_s.humanize}
    if args.last.is_a?(Hash)
      options = options.merge args.pop
    end
    link = link_to(options[:label], send("admin_#{args.first}_path"))
    if args.include?(controller.controller_name.to_sym)
      css_class = 'on'
    end
    content_tag('span', link, :class => css_class)
  end

  
  def visibility_toggle(link_text, element_id, visible_by_default = false, &block)
    html = link_to_function(link_text, "visibilityToggle(this,'#{element_id}')")
    html << content_tag('div', capture(&block), :id => element_id, :style => "display:#{visible_by_default ? 'block' : 'none'}")
    concat(html, proc.binding)
  end

  def spinner(name = :loading)
    image_tag('/images/admin/spinner.gif', :id => "#{name}_spinner", :style => 'display:none', :align => 'absmiddle')
  end
  
  
  def image_picker_widget(model,column,label_text = nil)
    label_text = column.to_s.humanize if label_text.nil?
    render :partial => 'admin/shared/image_picker_widget', :locals => {
      :model => model,
      :column => column,
      :label_text => label_text
      }
  end
  


  def time_select_tag(name = 'time', time = Time.now)
    select_time time, :prefix => name.to_s
  end


  def update_form(options = {}, &block)
    options = {:model => model_name, :method => :put}.update(options)
    model = options.delete(:model)
    form_for(model, instance_variable_get("@#{model}"), {:url => object_url,  :html => options}, &block)
  end

  def create_form(options = {}, &block)
    options = {:model => model_name}.update(options)
    model = options.delete(:model)
    form_for(model, instance_variable_get("@#{model}"), {:url => collection_url, :html => options}, &block)
  end
  
end
