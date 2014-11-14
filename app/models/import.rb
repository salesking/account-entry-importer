class Import < ActiveRecord::Base
  include UserReference

  has_many :data_rows, dependent: :destroy
  belongs_to :attachment, inverse_of: :imports

  default_scope ->{order('imports.id desc')}

  validates :attachment, presence: true

  after_save :populate_data_rows

  def title
    
    # title = "#{attachment.rows.size - 1} Einträge Importiert"
    scope = "imports.account_entry"
    title = I18n.t(:title_success, scope: scope, count: attachment.rows.size - 1)

    if (failed = data_rows.failed.count) > 0
      [title, I18n.t(:title_failed, scope: scope, count: failed)].to_sentence
    else
      title
    end
  end

  def preview(size = 3)
    mapping_elements = attachment.mapping.mapping_elements
    [mapping_elements.collect(&:target)] + attachment.rows[1..size].collect do |row|
      attachment.mapping.mapping_elements.collect do |mapping_element|
        mapping_element.convert(row)
      end
    end
  end

  # An import is successful if no rows failed
  def success?
    data_rows.exists? && !data_rows.failed.exists?
  end

  # private

  def populate_data_rows
    # drop header row
    data_to_populate = attachment.rows.drop(1)

    case attachment.mapping.import_type
    when 'account' then   populate_account_entries(data_to_populate)
    # when 'account'  then populate_many_accounts(data_to_populate)
    end

    data_rows(true)
  end

  def populate_account_entries(data_to_populate)
    # account_data_row = DataRows::AccountDataRow.create(import:self, data: data_to_populate)
    DataRows::AccountEntryDataRow.create(import: self, data: data_to_populate)
  end

  def populate_many_accounts(data_to_populate)
    data_to_populate.map do |row|
      DataRows::DocumentDataRow.create(import: self, data: row)
    end
  end

end
