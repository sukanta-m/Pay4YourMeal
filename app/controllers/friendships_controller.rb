class FriendshipsController < ApplicationController
  respond_to :html, :json, :js, :text
  before_action :authenticate_user!
  before_action :set_friend

  def create
    Friendship.request current_user, @friend
    SendNotificationEmailToSharedUsersWorker.new( @friend.id,current_user.id).requested
    get_friends
    respond_to do |f|
      f.js
    end
  end

  def update
    Friendship.accept current_user, @friend
    @requested_users = Friendship.requested(current_user)
    SendNotificationEmailToSharedUsersWorker.new(@friend.id,current_user.id).accepted
    get_friends
    respond_to do |f|
      f.js
    end
  end

  def destroy
    Friendship.where("(user_id = ? and friend_id = ?) or (user_id = ? and friend_id = ?) ",
                     current_user.id, @friend.id, @friend.id, current_user.id).destroy_all
    SharedBlog.where("(blogger_id = ? and user_id = ?) or (blogger_id = ? and user_id = ?)",
                     current_user.id, @friend.id, @friend.id, current_user.id).destroy_all
    get_friends
    respond_to do |f|
      f.js
    end
  end

  def get_requested_friends
    @requested_users = Friendship.requested(current_user)
    respond_to do |format|
      format.js
    end
  end

  private

  def frnd_params
    params.require(:friendship).permit(:user_id, :friend_id)
  end

  def set_friend
    @friend = User.find_by_id(params[:friend_id])
  end

  def get_friends
    @friends = current_user.friends
    @remaining_users = User.where.not(:id => current_user.id) - @friends
  end
end
