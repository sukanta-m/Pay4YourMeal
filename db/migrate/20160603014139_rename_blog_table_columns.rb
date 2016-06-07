class RenameBlogTableColumns < ActiveRecord::Migration
  def self.up
    rename_column :blogs, :is_private?, :is_private
    rename_column :blogs, :is_shared?, :is_shared
  end

  def self.down
    # rename back if you need or do something else or do nothing
  end
end
