require 'spec_helper'
describe Sk do
  it "should read schema" do
    hsh = Sk.read_schema('contact')
    expect(hsh['title']).to eq 'contact'
  end
end
