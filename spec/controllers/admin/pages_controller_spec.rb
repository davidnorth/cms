require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::PagesController do
  integrate_views

  before(:each) do
    activate_authlogic
    UserSession.create! Factory.build(:user, :admin => true)
    @global_nav = Factory(:top_level_folder)
  end

  it "should get index sucessfully" do
    get 'index'
    response.should be_success
  end

  it "should not create a page if attributes are not valid" do
    post 'create', :page => Factory.attributes_for(:page, :title => '')
    response.should be_success
    assigns(:page).should be_invalid
  end

  it "should create a page if attributes are valid, and it should default to type Page" do
    attrs = Factory.attributes_for(:page, :parent_id => @global_nav.id, :title => 'Newly created page')

    post 'create', :parent => @global_nav.id, :type => 'page', :page => attrs
    response.should be_redirect
    new_page = Page.find_by_title(attrs[:title])

    new_page.should_not be_nil
    new_page.parent.should == @global_nav
    new_page.class.to_s.should == 'Page'
  end
  
  it "should create a page as a child of the parent selected in the form" do
    parent = Factory(:page)

    attrs = Factory.attributes_for(:page, :parent_id => parent.id, :title => 'Newly created page')
    # Post with global nav as parent param which should be ignored in favour or params[:page][:parent_id]
    post 'create', :parent => @global_nav.id, :type => 'page', :page => attrs
    response.should be_redirect
    new_page = Page.find_by_title(attrs[:title])
    
    new_page.parent.should == parent
  end
  
  it "should create page of the chosen type" do
    attrs = Factory.attributes_for(:page, :title => 'Newly created page', :parent_id => @global_nav.id)
    post 'create', :type => 'news_index', :page => attrs
    response.should be_redirect
    new_page = Page.find_by_title(attrs[:title])
    new_page.class.to_s.should == 'NewsIndex'

  end

end
