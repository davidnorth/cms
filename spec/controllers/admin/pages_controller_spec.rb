require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::PagesController do

  before(:each) do
    activate_authlogic
    UserSession.create! Factory.build(:admin_user)
  end
    
  it "should get index sucessfully" do
    get 'index'
    response.should be_success
  end

end
