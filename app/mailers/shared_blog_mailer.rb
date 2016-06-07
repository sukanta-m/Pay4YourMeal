class SharedBlogMailer < ActionMailer::Base
  default from: "do-not-reply@gmail.com"
  def notify_user user, sender
    @user = user
    @sender = sender
    mail to: user.email, subject: "Shared blog"
  end
end