class AddAccountNumberToMappings < ActiveRecord::Migration
  def change
  	add_column :mappings, :account_number, :string, limit: 50
  end
end
