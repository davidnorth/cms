class Admin::AttachmentsController < Admin::BaseController
  setup_resource_controller
  belongs_to :page
  
  create.wants.js { render :action => "create" }
  create.flash nil
  
  create.before do
    @klass = @attachment.attachable_type.constantize
    @attachable = @klass.new(params[:attachable])
    @attachment.attachable = @attachable
  end
  

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
    existing_ids = @page.attachments.of_type(@klass.to_s).map(&:attachable_id)
    @content_items = @klass.excluding_ids(existing_ids).with_keyword(params[:q]).paginate(:page => params[:page], :per_page => 20)
  end
  
end
