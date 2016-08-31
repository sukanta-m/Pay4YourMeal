class GroupsController < ApplicationController
  respond_to :html, :json, :js, :text
  before_action :authenticate_user!
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  def index
    @groups = current_user.groups
  end

  def new
    @group = Group.new
  end

  def create
    if @group = current_user.groups.create(group_params.merge({:user_id => current_user.id}))
      member = Member.where(:user => current_user, :group => @group).first
      member.update_attributes(invited_by: current_user.id, is_accepted: true)
      session[:group_id] =@group.id
      flash[:success] = "#{@group.name} has been created"
      redirect_to groups_path
    else
      flash.now[:warning] = "Group has failed to create"
      render :new
    end
  end

  def show
    @users = @group.users
  end

  def edit
  end

  def any_group
    if current_user
      unless current_group
        @group = Group.new
        respond_to do |format|
          format.js
        end
      else
        render json: {status: 'success'}
      end
    else
      render json: {status: 'success'}
    end
  end

  def switch
    if params[:id] && session[:group_id] = params[:id]
      group = current_user.groups.find_by_id(params[:id])
      flash[:success] = "Now you are in #{group.try(:name)}"
    else
      flash[:warning] = "Failed to change the group"
    end
    redirect_to :back
  end

  def change_date
    session[:current_date] = params[:selected_date]
    redirect_to :back
  end

  private

  def group_params
    params.require(:group).permit(:name, :description, :user_id)
  end

  def set_group
    @group ||= current_user.groups.find_by_id(params[:id])
  end
end
