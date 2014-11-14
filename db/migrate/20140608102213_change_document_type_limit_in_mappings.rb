class ChangeDocumentTypeLimitInMappings < ActiveRecord::Migration
  def up
    change_column :mappings, :document_type, :string, limit: 12
  end

  def down
    change_column :mappings, :document_type, :string, limit: 10
  end
end
