class Admin::AttachmentsController < Admin::BaseController
  setup_resource_controller
  belongs_to :page
  
  def search
    @page = parent_object
    params[:type] ||= 'image'
    @klass = params[:type].camelize.constantize
    @results = @klass.with_keyword(params[:q]).paginate(:page => params[:page], :per_page => 20)
  end
  
end
