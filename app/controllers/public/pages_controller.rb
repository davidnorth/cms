class Public::PagesController < Public::BaseController
  include Public::PageTypes

  def view
    @rendered = false
    if params[:slug_path].is_a? Array
      slug_path = params[:slug_path].join('/')
    else
      slug_path = params[:slug_path]
    end
    @page = Page.find_by_slug_path(slug_path)    
    render_not_found and return if @page.nil? or !@page.visitable?
    @page_title = @page.meta_title.blank? ? @page.title : @page.meta_title
    unless @page.meta_keywords.blank?
      @meta_keywords = @page.meta_keywords
    end
    unless @page.meta_description.blank?
      @meta_description = @page.meta_description
    end
    # find the first news index to make an rss link
    @news_rss = Page.find(:first, :conditions => ["type = 'NewsIndex'"])
    @root_page = @page.root_ancestor
    # If the page is a NewsItem for example, automatically set it to the @news_item instance variable
    instance_variable_set("@#{@page.class.to_s.underscore}", @page)
    send(@page.public_method) if respond_to?(@page.public_method)
    render_page_type unless @rendered
  end

  private
  
  def render_page_type(template = nil)
    template = @page.public_template if template.nil?
    render :template => "public/page_types/#{template}"
    @rendered = true
  end
  
end