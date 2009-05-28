class DownloadList < Page

  admin_template 'page'
  
  allowed_child_types [:download]

end