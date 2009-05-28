Factory.define :user do |u|
  u.email "davidnorth@gmail.com"
  u.password "123456"
  u.password_confirmation {|u| u.password}
  u.single_access_token "k3cFzLIQnZ4MHRmJvJzg"
end



Factory.define :top_level_folder , :class => Page do |p|
  p.title "Global Nav"
  p.published true
  p.position 1
  p.publish_date { 1.week.ago }
end

Factory.define :page, :parent => :top_level_folder do |p|
  p.title "About Us"
  p.association :parent, :factory => :top_level_folder
end

