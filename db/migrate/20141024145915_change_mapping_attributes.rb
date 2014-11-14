class ChangeMappingAttributes < ActiveRecord::Migration
  def up
    rename_column :mappings, :document_id, :account_id
  end

  def down
    rename_column :mappings, :account_id, :document_id
  end
end
