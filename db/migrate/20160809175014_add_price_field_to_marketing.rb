class AddPriceFieldToMarketing < ActiveRecord::Migration
  def change
    add_column :marketings, :amount, :decimal
  end
end
