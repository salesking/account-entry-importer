require 'spec_helper'

describe Import do

  context 'Importer' do
    # before(:each) do
    #   DataRows::AccountEntryDataRow.any_instance.stub(:create_or_update_account).and_return true
    # end

    it { should have_many(:data_rows).dependent(:destroy) }
    it { should belong_to(:attachment) }

    it { should validate_presence_of(:attachment) }

    describe 'data import', vcr: true do

      let(:mapping)          { create(:mapping) }
      let!(:mapping_element1) { create(:account_entry_mapping_element, mapping: mapping, source: 2, target: 'name') }
      let!(:mapping_element2) { create(:price_account_entry_mapping_element, mapping: mapping, source: 3) }
      let!(:mapping_element3) { create(:account_entry_mapping_element, mapping: mapping, source: 10, target: 'quantity') }
      let(:attachment)       { create(:attachment, mapping: mapping) }
      let(:import)           { build(:import, attachment: attachment) }

      it 'creates data_rows and succeeds' do
        expect(lambda { import.save }).to change(DataRow, :count).by(1)
        expect(import).to be_success
      end

      context 'when mapping element does not match price_single' do
        let(:mapping2)          { create(:mapping) }
        let(:attachment2)       { create(:attachment, mapping: mapping2) }
        let(:import2)           { build(:import, attachment: attachment2) }

        it 'creates data_rows with price_single set to 1' do
          expect(lambda { import2.save }).to change(DataRow, :count).by(1)
          expect(import2).to be_success
          data_row = import2.data_rows.first
          expect(data_row.external_id).not_to be_nil
        end
      end
    end
  end
end
