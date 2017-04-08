class MealsController < ApplicationController
  respond_to :html, :json, :js, :text
  before_action :authenticate_user!

  def index
    @members = current_group.members.active
  end

  def create
    if params[:group_id]
      group = Group.find_by_id(params[:group_id])
      if group && params[:member_id]
        member = group.members.find_by_id(params[:member_id])
        if member
          meal = member.meals.find_or_initialize_by(created_at: member.meal_date(params[:day]), meal_type: params[:type])
          meal.is_taken = params[:value] ? true : false
          meal.save
        end
      end
      status = "success"
    else
      status = "failed"
    end
    render json: {"status" => status}
  end
end
