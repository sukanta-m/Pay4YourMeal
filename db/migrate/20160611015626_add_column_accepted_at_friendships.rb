class AddColumnAcceptedAtFriendships < ActiveRecord::Migration
  def self.up
    add_column :friendships, :accepted_at, :datetime
  end
end
