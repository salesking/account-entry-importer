class AddDocumentTypeToMappings < ActiveRecord::Migration
  def change
    add_column :mappings, :document_type, :string, limit: 10
  end
end
