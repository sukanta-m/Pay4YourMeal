class AddAddedMemberToMarketing < ActiveRecord::Migration
  def change
    add_column :marketings, :added_by, :integer
  end
end
