class ContactForm < Page
  
  can_have_children? true  

  admin_template 'page'

  allowed_child_types [:location_page]
end