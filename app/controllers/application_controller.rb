# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  extend ActiveSupport::Memoizable
  #include ExceptionNotifiable

  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  filter_parameter_logging :password, :password_confirmation
    
  
  before_filter :set_charset

	def render_not_found
		render :file => RAILS_ROOT + "/public/404.html", :status => "404 Not Found"
	end	

  def set_charset
    headers["Content-Type"] = "text/html; charset=UTF-8" 
  end

  # get all params that aren't blank and whose keys corespond to supplied valid_keys
  def build_search_filters(valid_keys)
    params.clone.symbolize_keys.select{|k,v| valid_keys.include?(k) and !v.blank?}.to_hash
  end

	# Lazy method to build paginator object for supplied row count
	def make_pager(count, per_page = 10, page_key = :page)
		Paginator.new(self,count, per_page, params[page_key])
	end


  helper_method :current_user
  
  
  protected
  
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end
  
    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.record
    end

    def require_user
      unless current_user
        session[:return_to] = request.request_uri
        flash[:notice] = "You must be logged in to access this page"
        redirect_to new_user_session_path
        return false
      end
    end

    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end  

    def access_denied
      flash[:error] = "You're not authorized to view that page"
      redirect_to new_user_session_path
      return false
    end



    # Fetch a paginated collection from the current controllers resource class or parent association
    #
    # If controller implements collection_filters which returns an array of filter names
    # corresponding to named scopes on the model, these scopes will be chained together before
    # paginating to filter the collection
    #
    # If controller implments collection_orderings, these will apply corresponding named scopes for ordering
    # The named scope allows a complicated ordering such as by a joined table column to be encapsulated in a simple name
    # that's suitable for use in a query string paramter
    def paginate_collection_with_filters
      find_in = end_of_association_chain

      if respond_to?(:collection_orderings) and params[:sort_by] and collection_orderings.include?(params[:sort_by])
        @sort_by = params[:sort_by]
        @sort_dir = params[:sort_dir] || 'asc'
        find_in = find_in.send("ordered_by_#{@sort_by}", @sort_dir)
      else
        # Won't need this after Rails 2.3 - has default ordering option
        if find_in.respond_to?(:ordered_by_default)
          find_in = find_in.ordered_by_default
        end
      end

      puts "in paginate_collection_with_filters"
      if respond_to?(:collection_filters)
        puts 'adding collection_filters'
        collection_filters.each do |field|
          if params[field] and !params[field].strip.blank?
            puts "adding filter #{field}"
            find_in = find_in.send("with_#{field}", params[field])
          end
        end
      end

      if respond_to?(:paginate?) and !paginate?
        find_in.find(:all)
      else
        find_in.paginate(:page => params[:page], :per_page => respond_to?(:per_page) ? per_page : 10)
      end
    end
    memoize :paginate_collection_with_filters

    helper_method :collection_filters


end