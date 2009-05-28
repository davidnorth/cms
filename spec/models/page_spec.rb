require File.dirname(__FILE__) + '/../spec_helper'

module PageSpecHelper
  def valid_page_attributes
    {
      :title => "Page Title"
    }
  end
end


describe Page do
  include PageSpecHelper

  before(:each) do
    @global_nav = Page.create(:title => "Global Nav")
    @page = Page.new
  end

  it "should not be valid when empty" do
    @page.should_not be_valid
  end

  it "should be valid with correct attributes" do
    @page.attributes = valid_page_attributes
    @page.should be_valid
  end
  
  it "should set slug correctly" do
    @page.attributes = valid_page_attributes
    @page.parent = @global_nav
    @page.save!
    @page.slug.should eql('page-title')
  end
  
  it "should set slug path correctly" do
    @page.attributes = valid_page_attributes
    @page.parent = @global_nav
    @page.save!
    @page2 = Page.create(:title => "Another Page", :parent => @page)
    @page2.slug_path.should eql('page-title/another-page')
  end

end
