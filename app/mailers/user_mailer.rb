class UserMailer < ActionMailer::Base
  default from: "do-not-reply@gmail.com"

  #send reset password reset link to user email to change password
  def password_reset user, url
    @user = user
    @url = url
    mail to: user.email, subject: "Reset password instructions"
  end
end
