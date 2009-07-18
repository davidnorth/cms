class FileUpload < ActiveRecord::Base

  ALLOWED_FILE_UPLOAD_EXTENSIONS = %w(jpg jpeg pdf doc xls png gif)

  has_attached_file :file, {
    :url =>                   "/upload/files/:id/:basename.:extension",
    :path => ":rails_root/public/upload/files/:id/:basename.:extension"
  }
  validates_attachment_presence :file, :message => 'not uploaded'
  #validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/gif', 'image/png']

  before_create :set_title_if_necessary

  def set_title_if_necessary
    if title.blank?
      self.title = file_name
    end
  end
  
  def file_name
    file_file_name
  end
  
  #
  # Attachable
  #
  
  has_many :attachments, :class_name => "::Attachment", :as => :attachable, :dependent => :destroy
  
  named_scope :with_keyword, lambda {|q| {:conditions => ["title LIKE ?", "%#{q}%"]} }
  named_scope :excluding_ids, lambda {|ids| {:conditions => ["id NOT IN (?)", ids]} }

  def thumb_url(size = 'large')
    "/images/admin/filetypes/#{size}/#{file_ext.downcase}.png"
  end

  def file_ext
    File.extname(file_file_name).gsub(".","")
  end

  def details
    file.content_type
  end
  
end
