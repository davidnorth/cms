class UserSessionsController < Public::BaseController

  skip_before_filter :require_user
  
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save!
      flash[:notice] = "Successfully logged in"
      redirect_to admin_dashboard_path
    else
      flash[:error] = "Login failed"
      render :action => 'new'
    end
  end
  
  def destroy
    @user_session = UserSession.new(params[:user_session])
    @user_session.destroy
    flash[:notice] = "Successfully logged out"
    redirect_to homepage_path
  end

end
