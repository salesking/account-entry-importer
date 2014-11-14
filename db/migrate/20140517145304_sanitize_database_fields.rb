class SanitizeDatabaseFields < ActiveRecord::Migration
  def change
    rename_column :attachments, :col_sep, :column_separator
    rename_column :attachments, :quote_char, :quote_character

    rename_column :data_rows, :sk_id, :external_id
  end
end
