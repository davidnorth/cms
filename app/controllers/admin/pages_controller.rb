class Admin::PagesController < Admin::BaseController
  setup_resource_controller

  def index
    @pages = Page.top_level
    @expand_ids = @pages.map(&:id)
    if params[:reveal] and Page.exists?(params[:reveal])
      @expand_ids += Page.find(params[:reveal]).ancestors.map(&:id)
    end
    @expand_ids = @expand_ids.uniq.sort
    @page = Page.new
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
    puts params.inspect
    params[:item].each_with_index do |item_id,index|
      if(Page.exists?(item_id))
        Page.find(item_id).update_attribute(:position, index+1)
      end
    end
    render :nothing => true
  end
  
  
  private



  def build_object
    return @object unless @object.nil?

    if params[:page]
      # After submitting form, use parent from select field
      parent_id = params[:page][:parent_id]
    else
      # Initially use parent param if it exists to pre-populate page's parent
      parent_id = params[:parent]
    end
    if parent_id and Page.exists?(parent_id)
      @parent = Page.find(parent_id)
    end    

    if !params[:type].blank? and Page::TYPE_CLASSES.include?(params[:type].to_sym)
      if @parent && @parent.allowed_child_types.include?(params[:type].to_sym)
        class_name = params[:type].camelize
      else
        class_name = 'Folder'
      end
    elsif @parent
      # Set the type based on the parent's type
      class_name = @parent.allowed_child_types.first.to_s.camelize
    else
      class_name = 'Folder'
    end

    @page = class_name.constantize.new(object_params)

    #@page.type_name = class_name.underscore
    @page.parent = @parent if @parent
    @object = @page
  end

  
end
