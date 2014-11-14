require 'spec_helper'

describe Mapping do
  it { should have_many(:mapping_elements).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:nullify)      }

  it { should validate_presence_of :mapping_elements }

  let(:mapping)   { build(:mapping, company_id: 'a company') }
  let!(:mapping2) { create(:mapping, company_id: 'another company') }

  let!(:mapping_element)          { build(:mapping_element,          mapping: mapping) }
  let!(:description_mapping_element)   { build(:description_mapping_element,   mapping: mapping) }
  let!(:price_account_entry_mapping_element) { build(:price_account_entry_mapping_element, mapping: mapping) }

  before do
    mapping.mapping_elements = [mapping_element, description_mapping_element, price_account_entry_mapping_element]
    mapping.save!
  end

  context 'scopes' do
    describe '.by_company' do
      subject { Mapping.by_company('a company') }
      it { should include(mapping) }
      it { should_not include(mapping2) }
    end
  end

  describe '#title' do
    it "should have the correct title" do
      mapping.reload
      expect(mapping.title).to eq '3 Felder: name, description, and price_single'
    end
  end
end
