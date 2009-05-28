require File.dirname(__FILE__) + '/../spec_helper'

module PageSpecHelper
end


describe Page do
  include PageSpecHelper

  before(:each) do
    @global_nav = Factory.create(:top_level_folder)
  end

  it "should not be valid when empty" do
    Factory.build(:page, :title => '').should be_invalid
  end

  it "should be valid with correct attributes" do
    Factory.create(:page).should be_valid
  end
  
  it "should set slug correctly" do
    @page = Factory.create(:page, :title => 'Page Title')
    @page.slug.should eql('page-title')
  end
  
  it "should set slug path correctly" do
    @page = Factory.create(:page, :title => 'About us')
    @sub_page = Factory.create(:page, :parent => @page, :title => 'Meet the team')
    @sub_page.slug_path.should eql('about-us/meet-the-team')
  end

end
