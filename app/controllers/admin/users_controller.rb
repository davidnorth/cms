class Admin::UsersController < Admin::BaseController
  setup_resource_controller
  before_filter :cant_destroy_self, :only => :destroy
  
  
  def cant_destroy_self
    if params[:id].to_i == @current_user.id
      flash[:error] = "You can't delete yourself"
      redirect_to collection_url
      return false
    end
  end

  
  def list_columns
    [:name, :email]
  end
  
end
