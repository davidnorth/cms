class Admin::ImagesController < Admin::BaseController
  setup_resource_controller
  layout :set_popup_layout

  show.response do |wants|
    wants.html 
    wants.xml {render :action => 'show', :layout => false}
  end

  def crop_settings
    load_object
  end
  
  def flex_crop
    load_object
    if request.post?
      @image.update_attributes({
        :resize => params[:resize], 
        :crop_x => params[:crop_x], 
        :crop_y => params[:crop_y],
        :crop_w => params[:crop_w], 
        :crop_h => params[:crop_h]
        })
        @image.recreate_cropped_image
        render :text => @image.to_xml    
    else
      respond_to do |wants|
        wants.html 
        wants.xml {render :action => 'flex_crop', :layout => false}
      end
    end
  end

  private
  
  def object_url
    admin_image_url(:popup => params[:popup])
  end

  def collection_url
    admin_images_url(:popup => params[:popup])
  end


end
