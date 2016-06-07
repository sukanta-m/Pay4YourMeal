class RenameSharedBlogFields < ActiveRecord::Migration
  def self.up
    rename_column :shared_blogs, :users_id, :user_id
    rename_column :shared_blogs, :blogs_id, :blog_id
  end
end
