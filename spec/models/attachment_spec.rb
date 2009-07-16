require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Attachment do
  before(:each) do
    @page = Factory.create(:page)
  end

  it "should be invalid if empty" do
    Attachment.new.should_not be_valid
  end

end
