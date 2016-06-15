class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  enum status: [:pending,:requested,:accepted,:rejected]

  validates :user_id, presence: true
  validates :friend_id, presence: true

  def self.request(user, friend)
    unless user == friend
      transaction do
        create(:user => user, :friend => friend, :status => 'pending')
        create(:user => friend, :friend => user, :status => 'requested')
      end
    end
  end

  def self.accept(user, friend)
    transaction do
      accepted_at = Time.now
      accept_one_side(user, friend, accepted_at)
      accept_one_side(friend, user, accepted_at)
    end
  end

  def self.accept_one_side(user, friend, accepted_at)
    request = find_by_user_id_and_friend_id(user, friend)
    request.status = 'accepted'
    request.accepted_at = accepted_at
    request.save!
  end

  def self.is_pending(user, friend)
    requested = find_by_user_id_and_friend_id(user,friend)
    requested.present? ? requested.status.presence == "pending" : false
  end

  def self.is_requested(user, friend)
    requested = find_by_friend_id_and_user_id(friend,user)
    requested.present? ? requested.status.presence == "requested" : false
  end

  def self.requested user
    User.joins("LEFT JOIN friendships on users.id = friendships.friend_id").where("friendships.status = 1 and friendships.user_id = ?", user.id)
  end
end
