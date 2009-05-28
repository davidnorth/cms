require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::ImagesController do

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

end
