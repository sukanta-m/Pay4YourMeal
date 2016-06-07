class ChangeColumnTypeInBlogs < ActiveRecord::Migration
  def self.up
    change_column :blogs, :is_private, 'boolean USING CAST(is_private AS boolean)', default: false
  end
end
