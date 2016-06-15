class API < Grape::API
  version 'v1', using: :header,vendor: 'blog_app'
  format :json
  formatter :json, Grape::Formatter::Rabl

  resource :users do
    desc "Get the unread blog count"
    get "/:id/unread_blog_count", :rabl => "unread_blog_count" do
      user = User.find_by_id(params[:id])
      if user.present?
        @counter_obj = OpenStruct.new({
                                      :unread_blogs_count => user.shared_blogs.unread.count
                                      })
      end
    end
  end

  resources :friendships do
    desc "Get the requested friends count"
    get "/:id/friend_request_count", :rabl => "requested_friends_count" do
      user = User.find_by_id(params[:id])
      if user.present?
        @counter_obj = OpenStruct.new({
                                          :requested_friends_count => Friendship.requested(user).count
                                      })
      end
    end
  end
end
