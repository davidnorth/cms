#
# Allow some application_helper methods to be used in the scoped form_for manner
#
class ActionView::Helpers::FormBuilder
  
  def label(method, text = nil)
    @template.label(@object_name,method,text)
  end

  def field(method, options = {})
    @template.field(@object_name,method,options)
  end

  %w(simple_collection_select error_message_on error_message_for_label field_has_error? class_if_error).each do |selector|
    src = <<-end_src
      def #{selector}(method, options = {})
        @template.send(#{selector.inspect}, @object_name, method, objectify_options(options))
      end
    end_src
    class_eval src, __FILE__, __LINE__
  end
 
end
