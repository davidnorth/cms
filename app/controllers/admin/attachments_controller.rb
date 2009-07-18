class Admin::AttachmentsController < Admin::BaseController
  setup_resource_controller
  belongs_to :page
  
  create.wants.js { render :action => "create" }

  def batch_update
    params[:attachments].each do |attachment_id, attributes|
      @page = parent_object
      attachment = @page.attachments.find(attachment_id)
      if attributes[:_delete]
        attachment.destroy
      else
        attachment.update_attributes(attributes)
      end
    end
    
    respond_to do |wants|
      wants.html { redirect_to collection_url }
      wants.js { render :action => "batch_update" }
    end
  end
  
  def search
    @page = parent_object
    params[:type] ||= 'image'
    @klass = params[:type].camelize.constantize
    @content_items = @klass.with_keyword(params[:q]).paginate(:page => params[:page], :per_page => 20)
  end
  
end
