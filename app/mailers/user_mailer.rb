class UserMailer < ActionMailer::Base
  default from: "do-not-reply@gmail.com"

  #send reset password reset link to user email to change password
  def password_reset user, url
    @user = user
    @url = url
    mail to: user.email, subject: "Reset password instructions"
  end

  def membership_request member, url
    @member = member
    @url = url
    mail to: member.user.email, subject: "Membership invitation"
  end
end
