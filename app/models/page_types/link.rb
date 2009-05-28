class Link < Page
  
  can_have_children? false

  show_in_nav? false

  visitable? false
  
  alias_attribute :linkname,:title
  alias_attribute :linkaddress,:body
  alias_attribute :linkdescription,:extra1
  
end