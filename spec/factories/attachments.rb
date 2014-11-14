FactoryGirl.define do
  factory :attachment do
    uploaded_data    { file_upload('test1.csv') }
    column_separator ','
    quote_character  '"'
    encoding         'utf-8'
    association      :mapping
  end
end
