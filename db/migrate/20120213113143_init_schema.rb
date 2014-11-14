class InitSchema < ActiveRecord::Migration
  def up
    create_table 'attachments', force: true do |t|
      t.string   'filename',      limit: 100
      t.string   'disk_filename'
      t.string   'company_id',    limit: 22
      t.string   'user_id',       limit: 22
      t.string   'col_sep',       limit: 1
      t.string   'quote_char',    limit: 1
      t.integer  'mapping_id'
      t.string   'encoding'

      t.timestamps
    end

    create_table 'data_rows', force: true do |t|
      t.integer  'import_id'
      t.string   'sk_id',      limit: 22
      t.text     'source'
      t.text     'log'
      t.string   'company_id', limit: 22
      t.string   'user_id',    limit: 22

      t.timestamps
    end

    create_table 'imports', force: true do |t|
      t.integer  'attachment_id'
      t.string   'company_id',    limit: 22
      t.string   'user_id',       limit: 22

      t.timestamps
    end

    create_table 'mapping_elements', force: true do |t|
      t.string   'target',     limit: 100
      t.string   'conv_type',  limit: 100
      t.string   'conv_opts'
      t.string   'source'
      t.integer  'mapping_id'

      t.timestamps
    end

    create_table 'mappings', force: true do |t|
      t.string   'company_id', limit: 22
      t.string   'user_id',    limit: 22

      t.timestamps
    end

  end

  def down
    raise 'Can not revert initial migration'
  end
end
