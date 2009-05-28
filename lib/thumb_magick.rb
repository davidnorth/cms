require "tempfile"
require "fileutils"

# fix Tempfile to work with mogrify by removing filename extension
class Tempfile
  def make_tmpname(basename, n)
    sprintf('%s%d-%d', basename, $$, n)
  end
end
    
#
# Really easy thumbnail creation using mogrify command rather than RMagick etc.
#
# Based on MiniMagick but more basic and easier to use. All it does is create croped and/or resized images
# Always uses a tempfile so original is not affected.
# 
# Example:
#  image = ThumbMagick::Image.new('magnifier.jpg')
#  image.crop('100x100').thumbnail('60x60').write('out.jpg').write('another.jpg')
#  # or:
#  image.cropped_thumbnail('60x60').write('out.jpg')
#
module ThumbMagick
  class Image
    
    def initialize(input_path)     
      raise 'Input path does not exist' unless File.exists?(input_path)
      @input_path = input_path
      verify_image(input_path)
      reset
      @original_width,@original_height = dimensions
    end
    
    # Recreate the tempfile from original image, so that further transformation 
    # can be performed form the original rather than cumulatively
    def reset
      File.open(@input_path, "rb") do |f|
        begin
          tmp = Tempfile.new("minimagic")
          tmp.binmode 
          tmp.write(f.read)
        ensure
          tmp.close
        end      
        @path = tmp.path
      end
      verify_image(@path)
      self
    end

    # Supply either symbol (see easy_crop) or x and y to anchor crop from
  	def crop(geometry, anchor = :mc, anchor_y = nil)
  	  if anchor.is_a?(Symbol)
        easy_crop(geometry, anchor)
	    else
	      manual_crop(geometry, anchor, anchor_y)
      end
  	end
  	
    # Supply symbol for which edge or corner to anchor image form when cropping (defaults to :mc for the center)
  	def easy_crop(geometry, anchor)
      ow,oh = dimensions # Before crop
  	  w,h = geometry.strip.split('x').map{|n|n.to_i} # Target dimensions
  		anchor_x, anchor_y = case anchor
  			when :tl
  				[ 0 , 0 ]
  			when :tc
  				[ ((ow - w) / 2.0).round , 0]
  			when :tr
  				[ ow - w , 0 ]
  			when :ml
  				[ 0 , ((oh - h) / 2.0).round ]
  			when :mc
  				[ ((ow - w) / 2.0).round , ((oh - h) / 2.0).round ]
  			when :mr
  				[ ow - w , ((oh - h) / 2.0).round ]
  			when :bl
  				[ 0 , oh - h]
  			when :bc
  				[ ((ow - w) / 2.0).round , oh - h ]
  			when :br
  				[ ow - w , oh - h]
  		end
  		manual_crop(geometry, anchor_x, anchor_y)
	  end
	  
	  def manual_crop(geometry, anchor_x, anchor_y)
  		mogrify(:crop, "#{geometry}+#{anchor_x}+#{anchor_y}")
  		self
    end
  	
  	
  	# Resize to fit within a bounding box
  	def thumbnail(geometry)
  	  mogrify(:thumbnail, geometry)
  	  self
    end
    
  	# Save a thumbnail that will be resized then cropped to desired size
  	# Either top and bottom or sides will be cropped off depending on the aspect ratio of original image and of desired dimensions
  	def cropped_thumbnail(geometry)
      ow,oh = @original_width,@original_height
  	  w,h = geometry.strip.split('x').map{|n|n.to_i}

  		if (ow.to_f / oh) < (w.to_f / h)
  			# narrow aspect ratio, width is the priority
  			resized_w = w
  			resized_h = ((w.to_f / ow) * oh).round # scale height to same ratio as width
  		else
  			# wide or square aspect ratio, height is the priority
  			resized_h = h
  			resized_w = ((h.to_f / oh) * ow).round # scale width to the same ratio as height
  		end
  		resize_to = [resized_w,resized_h].max

      thumbnail("#{resize_to}x#{resize_to}")
      crop(geometry)
  		self
  	end

    def dimensions
      run_command("identify -format %wx%h #{@path}").strip.split('x').map{|n|n.to_i}
    end    
  
    def verify_image(path)
      begin
        run_command("identify #{path}")
      rescue
        raise "The file #{path} is not a valid image"
      end
    end
    
    def run_command(command, *args)
      args = args.collect do |a|
        a = a.to_s
        unless a[0,1] == '-'  # don't quote switches
          "\"#{a}\""          # values quoted because they can contain characters like '>'
        else
          a
        end
      end
      output = `#{command} #{args.join(' ')}`
      if $? != 0
        raise "ImageMagick command (#{command} #{args.join(' ')}) failed: Error Given #{$?}"
      else
        return output
      end  
    end

    # Writes the temporary image that we are using for processing to the output path
    def write(output_path = nil)        
      output_path = @input_path if output_path.nil?
      FileUtils.copy_file @path, output_path
      verify_image(output_path)
      self
    end
    
    def mogrify(symbol, *args)
      args.push(@path) # push the path onto the end
      run_command("mogrify", "-#{symbol}", *args)
    end

  end
end
