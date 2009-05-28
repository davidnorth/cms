require File.dirname(__FILE__) + '/../spec_helper'

module UserSpecHelper
end

describe User do
  include UserSpecHelper

  before(:each) do
  end

  it "should succeed creating a new :valid_user from the Factory" do
    Factory.create(:valid_user).should be_valid
  end

  it "should not be valid with bad attributes" do
    Factory.build(:invalid_user).should be_invalid
  end
  
end
