class FaqQuestion < Page
  
  can_have_children? false

  show_in_nav? false

  visitable? false
  
  alias_attribute :question,:title
  alias_attribute :answer,:body
  
end