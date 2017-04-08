class Member < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  has_many :meals

  scope :active, -> { where(is_accepted: true) }

  def is_eaten day, meal_type
    meal = meals.where(created_at: meal_date(day), meal_type: meal_type).first
    meal ? meal.is_taken : false
  end

  def meal_date day
    DateTime.new(DateTime.now.year, DateTime.now.month, day.to_i)
  end

  def self.generate_token
    SecureRandom.urlsafe_base64
  end
end
