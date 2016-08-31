class AddColumnToMeals < ActiveRecord::Migration
  def change
    add_column :meals, :meal_type, :string
  end
end
