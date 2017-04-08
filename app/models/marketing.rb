class Marketing < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  scope :approved , -> { where(is_approved: true) }
  scope :approved_amount, -> { where(is_approved: true).sum(:amount) }
  scope :total_amount, -> { sum(:amount)}
  scope :from_this_month, ->(current_date) {where(marketing_on: current_date.beginning_of_month..current_date.end_of_month)}

  def is_accessible_by(current_user)
    user == current_user || group.owner == current_user
  end
end
