class AdminMailer < ActionMailer::Base
  default_url_options[:host] = 'www.pom-bear.co.uk'
  
  def new_member_notification(member)
    recipients ADMIN_EMAIL
    from       EMAIL_FROM
    subject "New member registered at #{SITE_NAME}"
    body       ({'member' => member})
  end  

  def member_message(member,message)
    recipients member.email
    from       EMAIL_FROM
    subject    "Important message from #{SITE_NAME}"
    body       ({'member' => member, 'message' => message})
  end
  
end
