class AddMembershipTokenToMembers < ActiveRecord::Migration
  def change
    add_column :members, :token, :string
  end
end
