FactoryGirl.define do
  #data row will look like this ["Test organization", "Test", "male_user", "test_user1@email.com", "Herr", "1980-01-10"]
  factory :mapping_element do
    mapping
    source 0
    target 'name'
    model_to_import 'account_entry'

    factory :account_entry_mapping_element do
      source 1
      target 'name'
    end    

    factory :name_mapping_element do
      source 1
      target 'name'
    end

    factory :description_mapping_element do
      source 3
      target 'description'
    end

    factory :price_account_entry_mapping_element do
      source 4
      conversion_type 'price'
      target 'price_single'
    end

    factory :quantity_account_entry_mapping_element do
      source 5
      target 'quantity'
    end
    
  end
end
