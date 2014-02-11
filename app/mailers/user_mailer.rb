class UserMailer < ActionMailer::Base
  default from: 'notifications@example.com'
  
  def send_mail(user_name)
    puts "USERMAILER send_mail "+user_name
    mail(to: "imuce9@gmail.com", subject: "test email")
  end
  
end
