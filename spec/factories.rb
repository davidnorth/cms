Factory.define :user do |u|
  u.email "davidnorth@gmail.com"
  u.password "123456"
  u.password_confirmation {|u| u.password}
  u.single_access_token "k3cFzLIQnZ4MHRmJvJzg"
end



Factory.define :top_level_folder , :class => Page do |p|
  p.title "Global Nav"
  p.published true
end

Factory.define :page do |p|
  p.title "About Us"
  p.published true
  p.parent   {|a| a.association(:top_level_folder) }
end

