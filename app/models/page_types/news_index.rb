class NewsIndex < Page

  archive? true
  
  admin_template 'page'
  
  allowed_child_types [:news_item]

  def latest_stories(number = 10)
    visible_children(:limit => number, :order => 'publish_date DESC')
  end
  
end