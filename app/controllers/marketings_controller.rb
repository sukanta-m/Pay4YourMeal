class MarketingsController < ApplicationController
  respond_to :html, :json, :js, :text
  before_action :authenticate_user!
  before_action :set_marketing, only: [:show, :destroy, :edit, :update, :approve, :copy]

  def new
    @marketing = Marketing.new
  end

  def create
    @marketing = current_group.marketings.new(marketing_params.merge({:added_by => current_user.id}))
    if @marketing.save
      flash[:success] = "Marketing has been created successfully"
      redirect_to root_path
    else
      flash.now[:warning] = "Marketing has failed to create"
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

  def copy
    @marketing = @marketing.dup
    @marketing.title = @marketing.title + " (copy)"
    render :new
  end

  def update
      if @marketing && @marketing.update_attributes(marketing_params)
        flash[:success] = "#{@marketing.title} has been updated successfully"
        redirect_to root_path
      else
        flash.now[:warning] = "#{@marketing.title} has failed to update"
        render :edit
      end
  end

  def destroy
    if @marketing && @marketing.destroy
      flash[:success] = "successfully deleted"
    else
      flash[:error] = "Failed to delte. Try again"
    end
    redirect_to root_path
  end

  def approve
    if @marketing
      @marketing.update_attributes(is_approved: !@marketing.is_approved)
    end
    @marketings = current_group.marketings
    @total_approved_amount = @marketings.approved_amount
    @total_amount = @marketings.total_amount
  end

  private

  def set_marketing
    @marketing ||= Marketing.find_by_id(params[:id])
  end

  def marketing_params
    params.require(:marketing).permit(:title, :description, :location, :amount, :marketing_on, :user_id)
  end

end
