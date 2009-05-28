#
# Actions for each page behaviour behaviour
#
module Public::PageTypes

  def redirect
    redirect_to @page.url
  end
  
  
  
  def news_index
    @news = @page.visible_children(:page => params[:page], :order => 'publish_date DESC')
    respond_to do |format|
      format.html { render_page_type }
      format.rss { render(:template => 'public/page_types/news_index.rss.builder', :layout => false) } and @rendered = true
    end
  end

  def news_item
    @news_item = @page
  end

  def contact_form
    if params[:sent] == '1'
      render_page_type(@page.public_template + '_sent')
    else
      @enquiry = Enquiry.new(:source => @page.title)
      if request.post?
        @rendered = true
        @enquiry.attributes = params[:enquiry]
        if @enquiry.save && verify_recaptcha(@enquiry)
          SiteMailer.deliver_enquiry(@enquiry)
#          SiteMailer.deliver_confirmation(@enquiry)
          
          if @enquiry.newsletter == true
            uri = URI.parse('http://bluestormnewmedia.createsend.com/t/1/s/nijx/')
            Net::HTTP.post_form(uri, {
               'mb-name' => @enquiry.name, 
               'mb-nijx-nijx' => @enquiry.email
             })
          end

          redirect_to view_page_url(:slug_path => @page.to_param, :sent => 1) and return
          
        else
          flash.now[:error] = 'Please check the details you provided'
        end
      end
      render_page_type
    end
  end
  
  
  def site_search
    #@results = Page.paginate_search(params[:q], :page => params[:page], :per_page => 10)
    @results = Ultrasphinx::Search.new(:query => params[:q])
    @results.run
    @results.results
    render_page_type
  end
  
  def paginated_index
    @pager = make_pager(@page.visible_children_count,10)
    @sub_pages = @page.visible_children(:pager => @pager)
  end
  
  def buy_page
    @retailers = Retailer.all
  end
  
  def case_study_list
    @case_studies = @page.visible_children(:page => params[:page])
  end

  def case_study
    @case_study = @page
  end

  def profile_list
    @profiles = @page.visible_children(:page => params[:page])
  end  

  def profile
    @profile = @page
  end

  def download_list
    @downloads = @page.visible_children(:page => params[:page])
  end  
  
  def products_page
    @ranges = @page.visible_children(:page => params[:page], :order => "publish_date DESC")
  end
  
  def product_range
      @categories = @page.visible_children(:page => params[:page], :order => "publish_date DESC")
  end

  def products_category
    @page_body = "products"
    unless params[:filter].blank?
      @filterparams = ProductCategory.find(params[:filter].to_i)
    end
  end

  def product_list
    @products = @page.visible_children(:page => params[:page])
  end  

  def testimonial_list
    @page_body = "testimonials"
  end  

  def gallery_list
    @galleries = @page.visible_children(:page => params[:page], :order => "publish_date DESC")
  end

  def link_list
    @links = @page.visible_children(:page => params[:page], :order => "title DESC", :per_page => 10)
  end
  
  def gallery
    @gallery = @page
  end
  
  def feature
    @feature = @page
  end

  def location_page
    @location_page = @page
  end 

end