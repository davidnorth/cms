class Admin::PagesController < Admin::BaseController
  setup_resource_controller

  index.before do
    if params[:view] == 'list'
      @expand_ids = []
    else
      @expand_ids = @pages.map(&:id)
      if params[:reveal] and Page.exists?(params[:reveal])
        @expand_ids += Page.find(params[:reveal]).ancestors.map(&:id)
      end
      @expand_ids = @expand_ids.uniq.sort
      @page = Page.new
    end
  end
  
  index.response do |wants|
    wants.html { render :action => (params[:view] == 'list' ? 'index_list' : 'index') }
  end

  create.response do |wants|
    wants.html { redirect_to edit_object_url }
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
  
  protected

  def collection_filters
    %w(type parent)
  end

  def collection
    if params[:view] == 'list'      
      paginate_collection_with_filters
    else
      Page.top_level
    end
  end

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

    @page.parent = @parent if @parent
    @object = @page
  end

end
