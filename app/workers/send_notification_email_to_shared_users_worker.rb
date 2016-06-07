class SendNotificationEmailToSharedUsersWorker
  @queue = :send_notification_email_to_shared_users_worker

  def self.perform user_ids, sender_id

    users = User.where(:id => user_ids)
    sender = User.find_by_id(sender_id)
    users.each do |user|
      SharedBlogMailer.notify_user(user, sender).deliver
    end if sender.present?
  end
end