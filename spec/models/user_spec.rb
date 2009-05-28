require File.dirname(__FILE__) + '/../spec_helper'

module UserSpecHelper
end

describe User do
  include UserSpecHelper

  before(:each) do
  end

  it "should create sucessfully with valid attributes" do
    Factory.create(:user).should be_valid
  end

  it "should not be valid with bad attributes" do
    Factory.build(:user, :email => 'foo').should be_invalid
  end
  
end
