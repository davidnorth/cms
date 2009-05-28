class Admin::PagesController < Admin::BaseController
  setup_resource_controller

  def index
    @pages = Page.top_level
    @expand_ids = @pages.map(&:id).join(',')
    if params[:reveal] and Page.exists?(params[:reveal])
      @expand_ids += ','+Page.find(params[:reveal]).ancestors.map(&:id).join(',')
    end
  end
  
  def children
    @page = Page.find(params[:id])
    @pages = @page.children.paginate(:page => params[:page], :order => 'publish_date DESC', :per_page => 10)
  end
  
  def reorder_children
    @parent = Page.find(params[:id])
    @page_title = "Reordering child items for &#8220;#{@page}&#8221; "
    @pages = @parent.children
    render :action => 'shared_reorder'
  end

  def reorder
    params[:items].each_with_index do |item_id,index|
      if(Page.exists?(item_id))
        Page.find(item_id).update_attribute(:position, index+1)
      end
    end
    render_nothing
  end
  
  
  private



  def build_object
    return @object unless @object.nil?
    if params[:parent] and Page.exists?(params[:parent])
      @parent = Page.find(params[:parent])
      if params[:type] and !params[:type].blank? and Page::TYPE_CLASSES.include?(params[:type].to_sym) and @parent.allowed_child_types.include?(params[:type].to_sym)
        class_name = params[:type].camelize
      else
        # Set the type based on the parent's type
        class_name = @parent.allowed_child_types.first.to_s.camelize
      end
    else
      class_name = 'Folder'
    end
    @page = eval(class_name).new(object_params)
    @page.type_name = class_name.underscore
    @page.parent = @parent if @parent
    @object = @page
  end

  
end
