Factory.define :user do |u|
  u.email "davidnorth@gmail.com"
  u.password "123456"
  u.password_confirmation {|u| u.password}
  u.single_access_token "k3cFzLIQnZ4MHRmJvJzg"
end



Factory.define :top_level_folder , :class => Folder do |p|
  p.title "Global Nav"
  p.published true
  p.position 1
  p.publish_date { 1.week.ago }
end

Factory.define :page do |p|
  p.title "About Us"
  p.position 1
  p.publish_date { 1.week.ago }
  p.association :parent, :factory => :top_level_folder
end

