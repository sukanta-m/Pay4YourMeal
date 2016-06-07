class ChangeBlogSharedColumnType < ActiveRecord::Migration

  def self.up
    change_column :blogs, :is_shared, 'boolean USING CAST(is_shared AS boolean)', default: false
  end

end
