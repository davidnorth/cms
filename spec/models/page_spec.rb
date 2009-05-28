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

  it "should set slug path correctly" do
    @page = Factory.create(:page, :title => 'About us')
    @sub_page = Factory.create(:page, :parent => @page, :title => 'Meet the team')
    @sub_page.slug_path.should eql('about-us/meet-the-team')
  end
  
  it "should find correct published children to show in nav" do
    global_nav = Factory.create(:top_level_folder)
    Factory(:page, :title => 'Published', :parent => global_nav)
    Factory(:page, :title => 'Published next week', :parent => global_nav, :publish_date => 1.week.from_now)
    Factory(:page, :title => 'Not published', :parent => global_nav, :published => false)
    global_nav.published_children_for_nav.length.should eql(1)
  end

end
