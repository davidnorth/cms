require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::PagesController do

  before(:each) do
    activate_authlogic
    UserSession.create! Factory.build(:user, :admin => true)
  end
    
  it "should get index sucessfully" do
    get 'index'
    response.should be_success
  end
  
  it "should not create a page if attributes are not valid" do
    post 'create', :page => Factory.attributes_for(:page, :title => '')
    response.should be_success
    assigns(:page).should be_invalid

  end
  

  it "should create a page if attributes are valie" do
    attrs = Factory.attributes_for(:page, :title => 'Newly created page')
    post 'create', :page => attrs
    response.should be_redirect
    Page.find_by_title(attrs[:title]).should_not be_nil
  end

end
