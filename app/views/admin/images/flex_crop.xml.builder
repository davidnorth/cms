xml.instruct! :xml, :version=>"1.0" 
xml.image {
  xml.crop(
    :crop_x => @image.crop_x, :crop_y => @image.crop_y, 
    :crop_w => @image.crop_w, :crop_h => @image.crop_h,
    :resize => @image.resize
    )
  xml.src homepage_url + uploaded_file_url(@image,:file,'tocrop')
}
