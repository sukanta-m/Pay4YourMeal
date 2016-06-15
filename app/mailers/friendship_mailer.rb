class FriendshipMailer < ActionMailer::Base
  default from: "do-not-reply@gmail.com"
  def notify_request user, sender
    @user = user
    @sender = sender
    mail to: user.email, subject: "Friend request" do |format|
      format.html { render layout: 'mailing' }
    end
  end

  def notify_accept user, sender
    @user = user
    @sender = sender
    mail to: user.email, subject: "Request accepted" do |format|
      format.html { render layout: 'mailing' }
    end
  end
end