#
# Helpers for building admin index filter forms
#
module Admin::FiltersHelper

  def filter_form(options = {}, &block)
    html = '<form method="get" id="list_filters"><fieldset>' + capture(&block) + '<input type="submit" value="Apply Filters" /></fieldset></form>'
    concat(html)
  end

  def collection_filter_tag(field, options = {})
    options[:collection] ||= eval(field.to_s.camelize).all
    options = content_tag('option') + options_from_collection_for_select(options[:collection], :id, :to_s, params[field].to_i)
    label_tag(field) + " " + select_tag("#{field}", options) + "&nbsp; "
  end

  def array_filter_tag(field, array, options = {})
    options = content_tag('option') + options_for_select(array, params[field])
    label_tag(field) + " " + select_tag("#{field}", options) + "&nbsp; "
  end

  def text_filter_tag(field, options = {})
    label_tag(field) + " " + text_field_tag(field, params[field], :style => "width:100px") + "&nbsp; "
  end
  
end
