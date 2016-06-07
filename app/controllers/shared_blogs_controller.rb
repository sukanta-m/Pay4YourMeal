class SharedBlogsController < ApplicationController
  respond_to :html, :json, :js, :text
  before_action :authenticate_user!
  before_action :set_blog

  def create
    already_shared_friends = @blog.linked_users.map{|user| user.id.to_s}
    unshared_friends = already_shared_friends - (params[:shared_friends] || [])
    shared_friends = (params[:shared_friends] || []) - already_shared_friends

    if params[:shared_friends].present?
      shared_friends.each do |user_id|
        shared_blog = @blog.shared_blogs.new(:user_id => user_id, :shared_date => DateTime.now)
        shared_blog.save
      end

      #send email notification to shared users
      Delayed::Job.enqueue(SendNotificationEmailToSharedUsersWorker.new( shared_friends,current_user.id))
      flash[:success] = "Notification email sent to shared users"
    else
      flash[:success] = "This blog didn't shared with anyone"
    end

    @blog.shared_blogs.where(:user_id => unshared_friends).delete_all
    @blog.update_attributes(:is_shared => @blog.shared_blogs.present?)

    redirect_to :back

  end

  private

  def set_blog
    @blog = current_user.blogs.find_by_id(params[:id])
  end
end
