class Meal < ActiveRecord::Base
  belongs_to :member

  scope :from_this_month, ->(current_date) {where(created_at: current_date.beginning_of_month..current_date.end_of_month)}

  def self.all_meals current_group, current_date
    Meal.where(member: current_group.members).from_this_month(current_date)
  end
end
