class SharedBlog < ActiveRecord::Base
  belongs_to :linked_user, class_name: "User", foreign_key: :user_id
  belongs_to :blogs_share, class_name: "Blog", foreign_key: :blog_id
  belongs_to :user
  belongs_to :blog
  scope :unread,-> { where(:is_read => false)}
end
