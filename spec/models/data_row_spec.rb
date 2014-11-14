require 'spec_helper'

describe DataRow do
  it { should belong_to(:import) }

  let(:import) { build(:import) }
  let(:data_row) { described_class.new(import: import) }

  let(:pfudor) { %w(pink fluffy unicorns dancing on rainbows) }

  describe '#mapping_element_assignment' do
    let(:object_to_assign) { nil }
    subject { data_row.send(:mapping_element_assignment, object_to_assign, pfudor) }

    it {should be_a Proc}

    context 'when proc called' do
      let(:objects_to_traverse) { [
        double(convert: 'PINK',     target: 'color'),
        double(convert: 'RAINBOWS', target: 'dancing_location'),
        double(convert: 'SMILE',    target: 'magical_fur_texture')
      ] }
      let(:object_to_assign) { double(:color= => 'PINK', :dancing_location= => 'RAINBOWS', :magical_fur_texture= => 'SMILE') }

      it 'passes mocks' do
        objects_to_traverse.each(&subject)
      end
    end
  end

  describe '#imported_class' do
    let(:attachment) { create(:attachment, mapping: mapping) }
    let(:import) { build(:import, attachment: attachment) }
    %w(account).each do |valid_class|
      context "when importing to #{valid_class}" do
        let(:mapping) { create(:mapping, document_type: valid_class) }

        subject { data_row.send(:imported_class) }
        it { should be Sk.const_get(valid_class.classify) }
      end
    end
  end
end
