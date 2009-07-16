class Admin::AttachmentsController < Admin::BaseController
  setup_resource_controller


  def search
    params[:type] ||= 'image'
    @klass = params[:type].camelize.constantize
    @results = @klass.with_keyword(params[:q]).paginate(:page => params[:page], :per_page => 2)
  end
  
end
