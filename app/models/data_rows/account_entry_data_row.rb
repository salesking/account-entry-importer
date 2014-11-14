module DataRows
  class AccountEntryDataRow < DataRow
    before_save :create_or_update_account

    private
    def create_or_update_account
      account.name = mapping.account_name
      account.budget = mapping.account_budget
      account.default_price = mapping.account_default_price
      if account.save
        mapping.update_attributes(account_number: account.number)
        self.external_id = account.id
        @data.map do |row|
          create_account_entry(row)
        end
      else
        self.source = @data.to_csv(col_sep: import.attachment.column_separator, quote_char: import.attachment.quote_character)
        self.log = account.errors.full_messages.to_sentence
      end
    end

    def create_account_entry(row)
      account_entry = Sk::AccountEntry.new
      account_entry_mapping_elements.each(&mapping_element_assignment(account_entry, row))
      account_entry.account_id = account.id
      account_entry.price_single = 1 if !account_entry.try(:price_single) && account.default_price.blank?
      account_entry.save
      account_entry
    end

    def account_entry_mapping_elements
      @account_entry_mapping_elements ||= mapping.mapping_elements.for_account_entries
    end

    def account
      @account ||= mapping.account_id.present? && imported_class.find(mapping.account_id).presence || imported_class.new
    end

  end
end
