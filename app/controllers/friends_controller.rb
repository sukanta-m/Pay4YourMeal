class FriendsController < ApplicationController
  respond_to :html, :json, :js, :text
  before_action :authenticate_user!

  def index
    get_friends
  end

  def search_user
    get_friends
    respond_to do |format|
      format.js
    end
  end

  private

  def get_friends
    @friends = current_user.friends
    if params[:search_text].present?
      @remaining_users = User.where.not(:id => current_user.id).where("(first_name || last_name) ilike ?", "%#{params[:search_text].gsub(/\s+/,'')}%") - @friends
    else
      @remaining_users = User.where.not(:id => current_user.id) - @friends
    end
  end
end
