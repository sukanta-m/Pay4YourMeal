class CreateBlogs < ActiveRecord::Migration
  def change
    create_table :blogs do |t|
      t.string :title
      t.text :description
      t.boolean :is_shared?
      t.integer :is_private?
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
