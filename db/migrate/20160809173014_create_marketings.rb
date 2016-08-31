class CreateMarketings < ActiveRecord::Migration
  def change
    create_table :marketings do |t|
      t.string :title
      t.text :description
      t.string :location
      t.datetime :marketing_on
      t.belongs_to :user

      t.timestamps null: false
    end
  end
end
