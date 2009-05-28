require File.dirname(__FILE__) + '/../spec_helper'

module ImageSpecHelper
  def get_image_fixture(filename = 'mm.jpg')
    File.open( File.join(RAILS_ROOT,'spec/fixtures/images',filename))
  end
end

describe Page do
  include ImageSpecHelper

  before(:each) do
  end

  it "should not be valid without an image file" do
    Image.new.should be_invalid
  end

  it "should be invalid if image is the wrong type of file" do
    Image.new(:image => get_image_fixture('mm.pdf')).should be_invalid
  end
  
  it "should be valid if image is an allowed type" do
    Image.new(:image => get_image_fixture('mm.jpg')).should be_valid
  end

end




