require 'test_helper'

class StaticPagesTest < ActionController::IntegrationTest
  fixtures :all
  
  test "should be able to visit some basic pages" do
    visit '/'
    assert_contain "Welcome"
  end

  test "should get 404 for non-existant page" do
    visit '/foo'
    assert_contain "404"
    assert_response :not_found
  end


end
