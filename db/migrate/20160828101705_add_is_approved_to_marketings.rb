class AddIsApprovedToMarketings < ActiveRecord::Migration
  def change
    add_column :marketings, :is_approved, :boolean, default: false
  end
end
