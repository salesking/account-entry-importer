require 'spec_helper'

describe Attachment do
  it { should belong_to(:mapping) }
  it { should have_many(:imports).dependent(:destroy) }

  ['filename', 'quote_character', 'encoding', 'disk_filename'].each do |attribute|
    it { should validate_presence_of(attribute)}
  end

  describe 'validations' do
    context 'column_separator' do
      let(:attachment) { build(:attachment) }

      it 'is valid present' do
        attachment.column_separator = ','
        attachment.valid?
        expect(attachment.errors).to_not include(:column_separator)
      end

      it 'is invalid when blank' do
        attachment.column_separator = nil
        attachment.valid?
        expect(attachment.errors).to include(:column_separator)
      end

      # "\t" is blank
      it 'is valid when blank, but \t' do
        attachment.column_separator = "\\t"
        attachment.valid?
        expect(attachment.errors).to_not include(:column_separator)
      end
    end
  end

  let(:attachment) { create(:attachment) }

  it 'should set filename and disk_filename' do
    expect(attachment.filename).to eq 'test1.csv'
    expect(attachment.disk_filename).not_to be_empty
  end

  it 'should remove file on destroy' do
    file_path = attachment.full_filename
    attachment.destroy
    expect(File.exist?(file_path)).to eq false
  end

  it 'should silently ignore missing files on destroy' do
    file_path = attachment.full_filename
    File.delete(file_path)
    expect(lambda {attachment.destroy}).not_to raise_error #(Errno::ENOENT)
  end

  it 'parses csv data' do
    expect(attachment.rows.size).to eq 5
    expect(attachment.rows.first.size).to be > 1
  end

  it 'reveals specified number of rows' do
    expect(attachment.rows(1).size).to eq 1
  end

end
