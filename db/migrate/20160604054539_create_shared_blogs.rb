class CreateSharedBlogs < ActiveRecord::Migration
  def change
    create_table :shared_blogs do |t|
      t.belongs_to :user
      t.belongs_to :blog
      t.datetime :shared_date

      t.timestamps null: false
    end
  end
end
