class NewsBroadcast < ActionMailer::Base
  
  def send_news(user, broadcast, email_list)
    #setup_email(user.user_detail, "Aber CS #{email_list} News")
    @firstname = user.firstname
    @title = broadcast.title
    @content = broadcast.content
    
    mail :to => user.email,  :subject => "Aber CS #{email_list} News"
  end

  #protected

  #def setup_email(user_detail, subject)
    #recipients   "#{user.email}"
    #from         "cwl@aber.ac.uk" # Sets the UserDetail FROM Name and Email
    #subject      subject
    #body         :user_detail => user_detail
    #sent_on      Time.now
    #content_type "text/html"
  #end
end
