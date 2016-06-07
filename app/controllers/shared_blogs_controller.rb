class SharedBlogsController < ApplicationController
  respond_to :html, :json, :js, :text
  before_action :authenticate_user!
  before_action :set_blog

  def create
    if params[:shared_friends].present?
      already_shared_friends = @blog.linked_users.map{|user| user.id.to_s}

      (params[:shared_friends] - already_shared_friends).each do |user_id|
        shared_blog = @blog.shared_blogs.new(:user_id => user_id, :shared_date => DateTime.now)
        shared_blog.save
      end
      @blog.shared_blogs.where(:user_id => (already_shared_friends - params[:shared_friends])).delete_all
      @blog.update_attributes(:is_shared => @blog.shared_blogs.present?)

      #send email notification to shared users
      Resque.enqueue(SendNotificationEmailToSharedUsersWorker, (params[:shared_friends] - already_shared_friends ),
                     current_user.id)
      flash[:success] = "Notification email sent to shared users"
      redirect_to :back
    end
  end

  private
  def set_blog
    @blog = current_user.blogs.find_by_id(params[:id])
  end
end