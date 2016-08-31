class CreateMeals < ActiveRecord::Migration
  def change
    create_table :meals do |t|
      t.belongs_to :member, index: true, foreign_key: true
      t.boolean :is_taken

      t.timestamps null: false
    end
  end
end
