class SiteMailer < ActionMailer::Base
  default_url_options[:host] = 'www.thirsty-planet.com'


  def enquiry(enquiry)
    recipients ADMIN_EMAIL 
    from       enquiry.email
    subject    "#{SITE_NAME} Enquiry"
    body       ({'enquiry' => enquiry})
  end

end
