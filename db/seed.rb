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

default_attributes = {
  "parent_id"=>global_nav.id,
  "published"=>true, 
  "publish_date"=> 2.days.ago, 
  "position"=>1, 
}

Homepage.create({
  "parent_id"=>global_nav.id,
  "published"=>true, 
  "slug"=>"home", 
  "intro"=>"The homepage intro", 
  "title"=>"Welcome to our shiny new website", 
  "body"=>"<p>\r\nLorem ipsum dolor sit amet, consectetuer adipiscing elit. Phasellus eros nunc, hendrerit vel, consectetuer non, luctus vel, tellus. </p>",
  "slug_path"=>"home", 
  "publish_date"=> 2.days.ago, 
  "position"=>1,
  "nav_title"=>"Home"
  })
Page.create(default_attributes.update({
  :title => "About Us",
  :intro => "We're great"
}))

Page.all.each &:save
