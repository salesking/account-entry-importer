require 'spec_helper'

describe DataRows::AccountEntryDataRow do

  it { should belong_to :import }

  let(:import) { build(:import) }
  let(:data_row) { described_class.new(import: import) }

  let(:pfudor) { %w( pink fluffy unicorns dancing 1 rainbows ) }
  let(:mapping_elements2) { ["id", "name", "dunno", "desciption", nil, "something"] }

  describe '#create_or_update_document' do
    skip
  end

  describe '#create_account_entry', vcr: true do
    let(:data_row) { described_class.new }
    before do
      data_row.stub(imported_class: Sk::Account, account_entry_mapping_elements: [create(:account_entry_mapping_element), 
        create(:price_account_entry_mapping_element),
        create(:description_mapping_element)])
      data_row.stub(account: double(id: "a3hTC2A9Wr5lfdabxfpGMl", default_price: nil))
    end

    it 'creates an account entry' do
      account_entry = data_row.send(:create_account_entry, pfudor)
      expect(account_entry.name).to eq 'fluffy'
      expect(account_entry.description).to eq 'dancing'
    end

    it 'sets price_single default to 1' do
      account_entry = data_row.send(:create_account_entry, mapping_elements2)
      expect(account_entry.price_single).to eq 1
    end
  end

  describe '#account_entry_mapping_elements' do
    let(:mapping) { create(:mapping) }
    let!(:account_entry_mapping_element) { create(:account_entry_mapping_element, mapping: mapping) }
    let(:attachment) { create(:attachment, mapping: mapping) }
    let(:import) { build(:import, attachment: attachment) }

    context 'for account entry' do
      subject { data_row.send(:account_entry_mapping_elements).last }
      it { should eq account_entry_mapping_element }
    end
  end

  describe '#mapping' do
    subject { data_row.send(:mapping) }

    it { should eq import.attachment.mapping }
  end
end
