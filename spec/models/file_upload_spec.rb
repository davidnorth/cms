require File.dirname(__FILE__) + '/../spec_helper'

module FileUploadSpecHelper
  def get_file_fixture(filename = 'test.xls')
    File.open( File.join(RAILS_ROOT,'spec/fixtures/files',filename))
  end
end

describe FileUpload do
  include FileUploadSpecHelper

  before(:each) do
  end

  it "should not be valid without a file" do
    FileUpload.new.should be_invalid
  end

  it "should be valid if image is an allowed type" do
    FileUpload.new(:file => get_file_fixture('test.xls')).should be_valid
  end

  it "should have a working factory" do
    file_upload = Factory.build(:file_upload)
    file_upload.should be_valid
    file_upload.save
    file_upload.file.exists?.should be_true
  end
end




