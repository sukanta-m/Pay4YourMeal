class Blog < ActiveRecord::Base

  belongs_to :user
  has_many :shared_blogs , dependent: :destroy
  has_many :linked_users, class_name: "User", through: :shared_blogs

  validates :title, presence: true, length: {maximum: 150}
  validates :description, presence: true

end
