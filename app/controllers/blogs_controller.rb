class BlogsController < ApplicationController

  respond_to :html, :json, :js, :text
  before_action :authenticate_user! , :except => [:show]
  before_action :set_blog, only: [:show, :destroy, :edit, :update, :shared_friends,:mark_private_public]

  def index
    @blogs = (params[:type] == 'private' ? current_user.blogs.where(:is_private => true).desc :
        (params[:type] == "public" ? current_user.blogs.where(:is_private => false).desc :
            (params[:type] == "latest" ? current_user.blogs.limit(10).desc : current_user.blogs.desc))) if current_user.present?
  end

  def new
    @blog = Blog.new
  end

  def create
    @blog = current_user.blogs.new(blog_params)
    if @blog.save
      flash[:success] = "Blog has been created successfully"
      redirect_to blog_path(@blog)
    else
      flash.now[:warning] = "Blog has failed to create"
      render :new
    end
  end

  def show
    if @blog.present? && @blog.is_private
      if current_user.blank?
        authenticate_user!
      elsif @blog.user != current_user && !@blog.linked_users.include?(current_user)
        flash[:warning] = "Sorry, you don't have authorize to view the blog"
        redirect_to blogs_path
      end
    elsif @blog.blank?
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def edit

  end

  def update
    if @blog.present?
      if @blog.update_attributes(blog_params)
        flash[:success] = "Blog has been updated successfully"
        redirect_to blog_path(@blog)
      else
        flash.now[:warning] = "Blog has failed to update"
        render :edit
      end
    end
  end

  def destroy
    @flag = false
    if @blog.present?
      @blog_id = @blog.id.to_s
      @flag = @blog.destroy
    end
    if request.xhr?
      respond_to do |format|
        format.js
      end
    else
      flash[:success] = "successfully deleted"
      redirect_to blogs_path
    end
  end

  #get lists of blogs shared by current_user
  def shared_blogs
    @shared_blogs = current_user.blogs.where(:is_shared => true ).desc
  end

  #get all the shared users with all users
  def shared_friends
    @friends = current_user.friends
    @shared_friend_ids = @blog.linked_users.map{|user| user.id.to_s} if @blog.present?
  end

  def mark_private_public
    if @blog.present?
      @blog.update_attributes(:is_private => !@blog.is_private)
      render json: {:status => 'success', :blog_id => @blog.id.to_s}
    else
      render json: {:status => 'failed'}
    end
  end

  def unread_blogs
    shared_blogs = current_user.shared_blogs.unread
    get_blogs(shared_blogs)
    shared_blogs.update_all(:is_read => true)
  end

  #get all blogs shared with me
  def received_blogs
    shared_blogs = current_user.shared_blogs
    get_blogs(shared_blogs)
  end

  private

  def set_blog
    @blog ||= Blog.find_by_id(params[:id])
  end

  def blog_params
    params.require(:blog).permit(:title, :description, :is_private, :is_shared, :user_id)
  end

  def get_blogs shared_blogs
    @blogs = shared_blogs.present? ? Blog.where(:id => shared_blogs.pluck(:blog_id) ).desc : []
  end
end
