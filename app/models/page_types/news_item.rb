class NewsItem < Page
  
  can_have_children? false
  
  def self.latest
  	find(:all, :order => 'created_at DESC', :limit => 1, :conditions => 'visible = "1"')
  end

end