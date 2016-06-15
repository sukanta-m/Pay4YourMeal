class AddColumnBlogerIdSharedBlogs < ActiveRecord::Migration
  def self.up
    add_column :shared_blogs, :blogger_id, :integer
  end
end
