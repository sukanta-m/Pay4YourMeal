class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :friend
      t.integer :status
      t.integer :requester_id

      t.timestamps null: false
    end
  end
end
