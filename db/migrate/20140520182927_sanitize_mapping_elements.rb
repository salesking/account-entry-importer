class SanitizeMappingElements < ActiveRecord::Migration
  def change
    rename_column :mapping_elements, :conv_type, :conversion_type
    rename_column :mapping_elements, :conv_opts, :conversion_options
  end
end
