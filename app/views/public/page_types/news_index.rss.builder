xml.instruct! :xml, :version=>"1.0" 
xml.rss(:version=>"2.0"){
  xml.channel{
    xml.title("#{SITE_NAME} - #{@page.title}")
    xml.link(homepage_url)
    xml.description("What your site is all about.")
    xml.language('en-gb')
      for story in @news
        xml.item do
          xml.title(story.title)
          xml.description(story.body)      
          xml.author(story.user.name)               
          xml.pubDate(story.created_at.strftime("%a, %d %b %Y %H:%M:%S %z"))
          xml.link(url_for_page(story))
          xml.guid(url_for_page(story))
        end
      end
  }
}