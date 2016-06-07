module BlogsHelper
  def get_submit_btn_name blog
    blog.new_record? ? "Create" : "Update"
  end

  def get_blog_status_title blog
    blog.is_private ? "public" : "private"
  end

  def get_blogs_view_header type
    "#{type.present? ? type.humanize : ''} Blogs List"
  end

  def is_blog_shared?(user_id,shared_friend_ids)
    shared_friend_ids.include?(user_id.to_s) ? true : false
  end
end
