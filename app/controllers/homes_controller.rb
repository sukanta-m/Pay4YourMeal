class HomesController < ApplicationController
  respond_to :html, :json, :js, :text
  before_action :authenticate_user! , :except => [:show]
  def index
    if current_group
      @marketings = current_group.marketings
      @total_approved_amount = @marketings.approved_amount
      @total_amount = @marketings.total_amount
    else
      flash[:info] = 'Please create group'
      redirect_to new_group_path
    end
  end
end
