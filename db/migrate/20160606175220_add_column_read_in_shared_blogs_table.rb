class AddColumnReadInSharedBlogsTable < ActiveRecord::Migration
  def self.up
    add_column :shared_blogs, :is_read, :boolean, default: false
  end
end
