class Admin::FileUploadsController < Admin::BaseController
  setup_resource_controller

  private
  
  def collection
    find_options = {}
    if params[:category]
      find_options[:conditions] = ["file_upload_category_id = ?",params[:category]]
    end
    find_options[:page] = params[:page]
    FileUpload.paginate(find_options)
  end
  
  def object_url
    admin_file_upload_url(:popup => params[:popup])
  end

  def collection_url
    admin_file_uploads_url(:popup => params[:popup])
  end

  def list_columns
    [:title, :file_name]
  end

  def human_model_name
    'File'
  end
  
end
