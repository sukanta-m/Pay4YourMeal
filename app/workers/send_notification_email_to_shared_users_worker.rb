class SendNotificationEmailToSharedUsersWorker
  attr_accessor :user_ids, :sender_id

  def initialize(user_ids, sender_id)
    self.user_ids = user_ids
    self.sender_id = sender_id
  end

  def perform
    users = User.where(:id => self.user_ids)
    sender = User.find_by_id(self.sender_id)
    users.each do |user|
      SharedBlogMailer.notify_user(user, sender).deliver
    end if sender.present?
  end
end