class Image < ActiveRecord::Base

  validates_presence_of :image

  has_attached_file :image, 
    :url =>                   "/upload/images/:id/:style_:basename.:extension",
    :path => ":rails_root/public/upload/images/:id/:style_:basename.:extension",
    :styles => { 
      :thumb => "80x80#", 
      :small => "100x100#",
      :medium => "140x140",
      :large => "290x290",
      :tocrop => ">650x650", # this version acts as original file for loading into the flash cropping editor
      :cropped => "650x650#"  # the default cropped image until user edits crop settings which will replace just this file with new one based of the "tocrop" version
    }
  validates_attachment_presence :image, :message => 'not uploaded'
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/gif', 'image/png']

  SIZES = %w(thumb small medium large cropped)

  after_create :store_image_dimensions_for_cropping
  
  # Sets the defaults for resize and crop settings based on the image uploaded
  # These will get overwritten and the cropped size re-created if cropping tool is used
  def store_image_dimensions_for_cropping
    puts "store_image_dimensions_for_cropping"
    if image.exists?
      puts "image exists"
      img = ThumbMagick::Image.new(image.path('tocrop'))
      w,h = img.dimensions
      puts "img.dimensions = #{img.dimensions.inspect}"
      self.crop_w = w
      self.crop_h = h
      self.crop_x = self.crop_y = 0
      save
    end
  end

  # Use resize_w,resize_h,crop_x,crop_y,crop_w and crop_h to recreate "cropped" image version
  def recreate_cropped_image
    if image.exists?
      img = ThumbMagick::Image.new(image.path('tocrop'))
      img.
        thumbnail("#{resize * 100}%").
        crop("#{crop_w}x#{crop_h}", crop_x, crop_y).
        write(image.path('cropped'))
    end    
  end

end
