class Admin::AttachmentsController < Admin::BaseController
  setup_resource_controller
  belongs_to :page
  
  create.wants.js { render :action => "create" }

  def batch_update
    params[:attachments].each do |attachment_id, attributes|
      parent_object.attachments.find(attachment_id).update_attributes(attributes)
    end
    redirect_to collection_url
  end
  
  def search
    @page = parent_object
    params[:type] ||= 'image'
    @klass = params[:type].camelize.constantize
    @content_items = @klass.with_keyword(params[:q]).paginate(:page => params[:page], :per_page => 20)
  end
  
end
