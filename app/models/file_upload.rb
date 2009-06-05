class FileUpload < ActiveRecord::Base

  ALLOWED_FILE_UPLOAD_EXTENSIONS = %w(jpg jpeg pdf doc xls png gif)

  has_attached_file :file, {
    :url =>                   "/upload/files/:id/:basename.:extension",
    :path => ":rails_root/public/upload/files/:id/:basename.:extension"
  }
  validates_attachment_presence :file, :message => 'not uploaded'
  #validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/gif', 'image/png']


end
