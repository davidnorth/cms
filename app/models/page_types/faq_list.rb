class FaqList < Page

  admin_template 'page'
  
  allowed_child_types [:faq_question]
  
  # Add the questions to the search index
  def extra_search_text
    visible_children.map{|c| "#{c.title} #{c.intro} #{c.body}"}.join(' ')
  end

end