require 'spec_helper'
describe User do
  describe 'new' do

    it 'sets values' do
      user = User.new(user_id: 'some-id', company_id: 'some-other-id')
      expect(user.user_id).to eq 'some-id'
      expect(user.company_id).to eq 'some-other-id'
    end

    # let(:user) { User.new(user_id: 'some-id', company_id: 'some-other-id') }
    #
    # it {  expect(user.user_id).to eq 'some-id' }
    # it {  expect(user.company_id).to eq 'some-other-id' }
  end
end
