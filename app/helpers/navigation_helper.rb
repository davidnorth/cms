module NavigationHelper
  
  def render_list_nav(parent = Page.find_by_title('Global nav'), depth = 1)
    pages = parent.published_children_for_nav
    return '' if pages.empty?
    list_items = pages.map do |page|
      current = @root_page == page || @page == page || (@page and @page.ancestors.include?(page) and !@page.top_level?)
      open = (current and page.published_children_for_nav.length > 0 and !page.archive?)      
      
      css_classes = []
      css_classes << 'current' if current
      css_classes << 'withsubnav' if open
      css_classes << 'last' if page == pages.last
      css_class = css_classes.join(' ') unless css_classes.empty?

      item_contents = link_to_page(page)
      item_contents << render_list_nav(page, depth+1) if open
      '  '*depth + content_tag('li', item_contents, :class => css_class)
    end
    content_tag('ul', "\n#{list_items.join("\n")}\n", :class => 'nav')
  end

  def render_global_nav
    pages = Page.find_by_title('Global nav').published_children_for_nav
    list_items = pages.map do |page|
      css_class = page.nav_title.url_friendly
      css_class << ' first' if page == pages.first
      css_class << ' last' if page == pages.last
      if page == @root_page
        css_class << " current"
      end
      content_tag('li', link_to(content_tag('span',page.nav_title),url_for_page(page)), :class => css_class)
    end
    content_tag('ul', "\n#{list_items.join('')}\n", :id => "main_navigation")
  end

  def render_site_map(pages = Page.find_published_top_level, depth = 1)
    list_items = []
    pages.each do |page|
      html = link_to_page(page)
      if !page.archive? and page.published_children_for_nav.length > 0
        html << render_site_map(page.published_children_for_nav, depth + 1)
      end
      list_items << content_tag('li',html)
    end
    content_tag('ul', list_items.join("\n"), :id => (depth == 1 ? 'sitemap' : nil))
  end
  
  def link_to_page(page, prefix = '')
    link_to(prefix + page.nav_title, url_for_page(page))
  end
  
  def page_list_item(page)
    content_tag('li', link_to_page(page), :class => (@page == page ? 'current' : nil))
  end

  def url_for_page(page)
    case page.class.to_s
    when 'Hyperlink'
      page.url
    when 'Folder'
      url_for(:controller => 'public/pages', :action => 'view', :slug_path => page.children.first.slug_path.split('/'), :only_path => false)
    else
      if page.to_param == 'home'
        homepage_url
      else
        url_for(:controller => 'public/pages', :action => 'view', :slug_path => page.slug_path.split('/'), :only_path => false)
      end
    end
  end
  
  def render_breadcrumb
    return unless @page
    return if homepage?
  	elements = @page.ancestors.reverse.map {|p| link_to_page(p)}
    if @extra_breadcrumb_text
    	elements << @extra_breadcrumb_text
    else
    	elements.shift
    	elements << @page.nav_title
    end
  	elements = [link_to('Home', homepage_url)] + elements
  	content_tag('p', '<strong>You are here:</strong> ' + elements.join(' &raquo; '), :id => 'breadcrumb')
  end
  
  def homepage?
    @page and @page.slug == 'home'
  end
    
end
