class PrepareImportsForMultipleTypes < ActiveRecord::Migration
  def change
    rename_column :mappings, :type, :import_type

    add_column :data_rows, :type, :string, limit: 40
    add_column :data_rows, :document_data_row_id, :integer

    add_column :mapping_elements, :model_to_import, :string, limit: 15

    add_column :mappings, :document_id, :string, limit: 22
  end
end
