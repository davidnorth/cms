require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::ImagesController do
  integrate_views

  before(:each) do
    activate_authlogic
    UserSession.create! Factory.build(:user, :admin => true)
  end

  it "should get index sucessfully" do
    get 'index'
    response.should be_success
  end
  
  it "should get new form sucessfully" do
    get 'new'
    response.should be_success
  end
  
  it "should create sucessfully" do
    Image.any_instance.stubs(:valid?).returns(true)
    post 'create'
    response.should be_redirect
  end

  it "should update sucessfully"
  
end
