class AddAccountInfoToMapping < ActiveRecord::Migration
  def change
    add_column :mappings, :account_name, :string, limit: 100
    add_column :mappings, :account_budget, :numeric
    add_column :mappings, :account_default_price, :numeric
  end
end
