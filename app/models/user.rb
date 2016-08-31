class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :first_name, presence: true
  validates :last_name, presence: true

  has_many   :marketings
  has_many   :members
  has_many   :active_members, -> {where is_accepted: true}, class_name: 'Member'
  has_many   :groups, through: :active_members

  def full_name
    "#{first_name} #{last_name}"
  end

  def get_current_group group_id = nil
    group_id.blank? ? groups.order("created_at desc").first : groups.find_by_id(group_id)
  end

  def send_password_reset url
    raw,reset_token = Devise.token_generator.generate(self.class, :reset_password_token)
    self.reset_password_token = reset_token
    self.reset_password_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self,url).deliver
  end

  def send_membership_request member, url
    UserMailer.membership_request(member, url).deliver
  end

  def meals_count group, current_date
    meals_count = 0
    member = group.members.find_by_user_id(self.id)
    if member
      meals_count = member.meals.from_this_month(current_date).count
    end
    meals_count
  end

  def spent_amount(current_group, current_date)
    marketings.from_this_month(current_date).sum(:amount)
  end

  def total_amount_till(current_group, current_date)
    member = Member.where(user: self, group: current_group).first
    amount_spent_for_self = 0.0
    if member
      total_meals = Meal.all_meals(current_group, current_date).count
      if total_meals > 0
        meals_count = member.meals.from_this_month(current_date).count
        total_amount = current_group.all_marketings(current_date).sum(:amount)
        amount_spent_for_self = (meals_count * total_amount / total_meals).round(2)
      end
    end
    amount_spent_for_self
  end

  def due(current_group, current_date)
    spent_amount(current_group, current_date) - total_amount_till(current_group, current_date) || 0
  end
end
