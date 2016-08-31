class AddGroupIdToMarketing < ActiveRecord::Migration
  def change
    add_reference :marketings, :group, index: true, foreign_key: true
  end
end
