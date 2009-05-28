# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
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



end