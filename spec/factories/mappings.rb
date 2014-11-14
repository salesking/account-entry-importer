FactoryGirl.define do
  factory :mapping do
    import_type   				'account'
    account_id						'a3hTC2A9Wr5lfdabxfpGMl'
    account_name					'Test Konto'
    account_budget				'1000'
    account_default_price	'35'
    account_number				'00025'
    mapping_elements = []

    before(:create) do |mapping|
      mapping.mapping_elements << build(:mapping_element, mapping: mapping) unless mapping.mapping_elements.present?
    end
  end
end
