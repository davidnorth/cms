user = User.new({
  :firstname => 'David',
  :lastname => 'North',
  :email => "davidnorth@gmail.com",
  :password => '123123',
  :password_confirmation => '123123'  
})
user.admin = true
user.save!

global_nav = Folder.create(:title => 'Global nav', :position => 1, :published => true, :locked => true, :publish_date => 2.days.ago)
Folder.create(:title => 'Footer nav', :position => 2, :locked => true)
Folder.create(:title => 'Other pages', :position => 3, :locked => true)


def default_attributes
  {
  "published"=>true, 
  "publish_date"=> 2.days.ago, 
  "position"=>1,
  "intro" => Faker::Lorem.sentence(10),
  :body => Faker::Lorem.paragraphs(2).join("\n\n")
  }
end

Homepage.create(default_attributes.update({
  "parent_id"=>global_nav.id,
  "published"=>true, 
  "slug"=>"home", 
  "title"=>"Welcome to our site", 
  "slug_path"=>"home", 
  "publish_date"=> 2.days.ago, 
  "position"=>1,
  "nav_title"=>"Home"
  }))
Page.create(default_attributes.update({
  :title => "About Us", :parent => global_nav
}))

services = Folder.create(default_attributes.update({
  :title => "Services", :parent => global_nav
}))
Page.create(default_attributes.update({
  :title => 'Programming', :parent => services
}))
Page.create(default_attributes.update({
  :title => 'Design', :parent => services
}))



Page.all.each &:save
