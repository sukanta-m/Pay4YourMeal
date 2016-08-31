class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.integer :invited_by
      t.belongs_to :group, index: true, foreign_key: true
      t.datetime :respond_on
      t.boolean :is_accepted

      t.timestamps null: false
    end
  end
end
