class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/, message: 'invalid file type. Please upload image file'

  validates :first_name, presence: true
  validates :last_name, presence: true

  has_many :blogs, dependent: :destroy
  has_many :shared_blogs, dependent: :destroy
  has_many :blogs_shares, class_name: "Blog", through: :shared_blogs

  def full_name
    "#{first_name} #{last_name}"
  end

  def send_password_reset url
    raw,reset_token = Devise.token_generator.generate(self.class, :reset_password_token)
    self.reset_password_token = reset_token
    self.reset_password_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self,url).deliver
  end
end
