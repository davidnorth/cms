class Page < ActiveRecord::Base

  # Get a list of valid type class names from the contents of the page_types directory
  TYPE_CLASSES = [:page] + Dir[RAILS_ROOT + '/app/models/page_types/*.rb'].map{|f| f.split('/').last.gsub(/\.rb$/,'').to_sym  }

  named_scope :published, :conditions => 'published = 1 AND publish_date <= NOW() '
  named_scope :top_level, :conditions => 'parent_id IS NULL'

  
  validates_presence_of :title

  acts_as_tree :order => 'position'

  before_save :set_slug, :set_paths
  after_save :set_child_paths

  attr_accessor :type_name
  

  #
  # Add a class method for various options that allows a simple macro type method to be used 
  # in class definitions to simply add an instance method of the same name that returns the
  # supplied value. This way you can avoid having to write lots on one line methods that 
  # just return a value, but if required, the method can still be defined normally allowing
  # the return value to be the result of some expression
  #
  # visitable? false
  #
  # instead of...
  #
  # def visitable?
  #   false
  # end
  #
  #
  class << self    
    option_methods = %w(can_have_children? visitable? deleteable? allowed_child_types archive? show_in_nav? admin_template public_template public_method)
    option_methods.each do |name|
      define_method name do |value|
        define_method name do
          value
        end
      end
    end
  end

  # Most types other than Folders and regular pages can't have children
  can_have_children? true

  # The content of some types populates their parent but they're not
  # a viewable page in their own right. Those types may overide this
  visitable? true
  
  deleteable? true
  
  allowed_child_types [:page,:folder,:news_index,:download_list,:faq_list,:hyperlink,:redirect]

  archive? false
  
  show_in_nav? true

  def admin_template
    page_type_name
  end
  
  def public_template
    page_type_name
  end

  def public_method
    page_type_name
  end
  
  def page_type_name
    self.class.to_s.underscore
  end




  def self.find_published_top_level
    find_top_level.map{|p| p.published_children}.flatten.select{|p| p.show_in_nav?}
  end

  def published_children(options = {})
    find_options = {}
    if options[:type]
      find_options[:conditions][0] << 'AND type = ? '
      find_options[:conditions] << options[:type]
    end
    if options[:limit]
      find_options[:limit] = options[:limit]
    end
    if options[:order]
      find_options[:order] = options[:order]
    end
    if options.has_key?(:page)
      find_options[:page] = options[:page]
      find_options[:per_page] = options[:per_page]
      children.published.paginate(find_options)
    else
      children.published.find(:all, find_options)
    end
  end

  def published_children_count
    children.published.count
  end

  def published_children_for_nav
    @published_children_for_nav ||= children.published.find(:all, :order => 'position').select{|c| c.show_in_nav?}
  end

  def root_ancestor
    ancestor = self
    while ancestor.parent.parent
      ancestor = ancestor.parent
    end
    ancestor
  end

  # Is this page a top level item in the site structure, not necessarily in the 
  # whole content tree where it may be a child of 'Global Nav' etc.
  def top_level?
    slug == slug_path
  end


  def children_count
    children.count
  end
  

  def to_s
    title
  end
  
  

  def nav_title
    if attributes['nav_title'].blank?
      title
    else
      attributes['nav_title']
    end
  end

  def set_slug
    self.slug = if parent.nil?
      nil
    else
      nav_title.url_friendly
    end
  end
  
  def set_paths
    if parent.nil?
      self.slug_path = nil
    else
      self.slug_path = (ancestors.map(&:slug).reject{|a|a.blank?}.reverse << slug).join('/')
    end
    #self.title_path = (ancestors.map(&:title).reject{|a|a.blank?}.reverse << title).join(' &gt; ')
  end
  
  def set_child_paths
    children.each do |child|
      child.set_paths
      child.save
      unless child.children.count == 0
        child.set_child_paths
      end
    end
  end

end
