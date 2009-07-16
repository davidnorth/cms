require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Attachment do
  before(:each) do
    @page = Factory.create(:page)
  end

  it "should be invalid if empty" do
    Attachment.new.should_not be_valid
  end

  it "should be valid if it has a page and attachable" do
    file_upload = Factory(:file_upload)
    attachment = Attachment.new(:page => @page, :attachable => file_upload)
    attachment.should be_valid
  end
  
end
