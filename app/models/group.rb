class Group < ActiveRecord::Base
  has_many   :members
  has_many   :active_members, -> {where is_accepted: true}, class_name: 'Member'
  has_many   :users, through: :active_members
  has_many   :marketings
  belongs_to :author, class_name: 'User', foreign_key: :user_id
  belongs_to :user
  validates :name, presence: true

  def all_marketings current_date
    marketings.approved.from_this_month(current_date)
  end
end
