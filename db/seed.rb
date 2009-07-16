user = User.new({
  :firstname => 'Your',
  :lastname => 'Name',
  :email => "youremail@example.com",
  :password => 'password',
  :password_confirmation => 'password'
})
user.admin = true
user.save!
 
global_nav = Factory(:top_level_folder)
Factory(:top_level_folder, :title => 'Footer nav')
Factory(:top_level_folder, :title => 'Other pages')

# Homepage
Factory(:page, :published => true, :position => 1, :parent => global_nav, :title => 'Welcome to our site', :slug_path => 'home', :nav_title => 'Home')

# Folder with basic sub pages
about_us = Factory(:folder, :published => true, :position => 2, :parent => global_nav, :title => "About us")
Factory(:page, :published => true, :parent => about_us, :title => 'Services')
Factory(:page, :published => true, :parent => about_us, :title => 'Company')

Page.all.each &:save