class SendNotificationEmailToSharedUsersWorker
  attr_accessor :user_ids, :sender_id

  def initialize(user_ids, sender_id)
    self.user_ids = user_ids
    self.sender_id = sender_id
  end

  def perform
    users
    @users.each do |user|
      SharedBlogMailer.notify_user(user, @sender).deliver_now
    end if @sender.present?
  end

  def requested
    users
    @users.each do |user|
      FriendshipMailer.notify_request(user, @sender).deliver_now
    end if @sender.present?
  end

  def accepted
    users
    @users.each do |user|
      FriendshipMailer.notify_accept(user, @sender).deliver_now
    end if @sender.present?
  end

  private

  def users
    @users = User.where(:id => self.user_ids)
    @sender = User.find_by_id(self.sender_id)
  end

end