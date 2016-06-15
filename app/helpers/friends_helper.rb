module FriendsHelper
  def get_button_tag user
    if Friendship.is_pending(current_user, user)
      h button_tag "Requested", class: "btn btn-success",
                 data: {href: friendships_path(:friend_id => user.id.to_s)}
    elsif Friendship.is_requested(current_user,user)
      h button_tag "Accept", class: "btn btn-primary accept-friend-request",
                   data: {href: friendship_path(user, :friend_id => user.id)}
    else
      h button_tag "Add friend", class: "btn btn-default send-friend-request",
                   data: {href: friendships_path(:friend_id => user.id.to_s)}
    end

  end
end
