# -*- encoding : utf-8 -*-
require 'spec_helper'
describe MappingElement do

  describe 'in general' do

    it 'validates convert type' do
      obj = MappingElement.new :conversion_type => 'what', :source=>'0'
      expect(obj).not_to be_valid
      expect(obj.errors[:conversion_type]).not_to be_empty
    end
  end

  describe 'convert' do

    it 'returns field value' do
      obj = MappingElement.new :source=>'0'
      expect(obj.convert(['Pipi'])).to eq 'Pipi'
    end

    it 'converts enum' do
      obj = MappingElement.new conversion_options: JSON.parse('{"male":"Herr","female":"Frau"}'), conversion_type: 'enum', source: '0'
      expect(obj.convert(['Frau'])).to eq 'female'
    end

    it 'converts date' do
      obj = MappingElement.new conversion_options: JSON.parse('{"date":"%d.%m.%Y"}'), conversion_type: 'date', source: '0'
      expect(obj.convert(['1.6.1976'])).to eq "1976.06.01"
    end

    it 'converts date without time' do
      obj = MappingElement.new conversion_options: JSON.parse('{"date":"%d.%m.%Y"}'), conversion_type: 'date', source: '0'
      expect(obj.convert(['1.6.1976 00:00:00'])).to eq "1976.06.01"
    end

    it 'converts date and rescue with incoming string' do
      source = ['1/6/1976 00:00:00']
      obj = MappingElement.new conversion_options: JSON.parse('{"date":"%d.%m.%Y"}'), conversion_type: 'date', source: '0'
      expect(obj.convert(source)).to eq source[0]
    end

    it 'converts joined fields' do
      source = %w(tag1 tag2 tag3 other)
      obj = MappingElement.new conversion_type: 'join', source: '0,1,2'
      expect(obj.convert(source)).to eq source[0..2].join(' ')
    end
  end

  describe :convert_price do
    let(:mapping_element) { MappingElement.new conversion_type: 'price', source: 0 }

    subject { mapping_element.convert([source]) }

    context 'converts prices with no whitespace' do
      let(:source) { '$32.79' }
      it { should eq '32.79' }
    end

    context 'converts prices with whitespace' do
      let(:source) { '€ 23.49' }
      it { should eq '23.49' }
    end

    context 'converts prices with trailing symbol' do
      let(:source) { '6900 元' }
      it { should eq '6900' }
    end

    context 'converts prices with trailing characters' do
      let(:source) { '70,39 zł' }
      it { should eq '70,39' }
    end

    context 'converts prices from float-like strings' do
      let(:source) { '20.30' }
      it { should eq '20.30' }
    end
  end
end
