require 'simplecov'
SimpleCov.start 'rails' do
  add_filter "/vendor/"
end
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
# require 'vcr'
# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/cassettes'
  config.configure_rspec_metadata!
  config.hook_into :webmock
  config.allow_http_connections_when_no_cassette = true
end

# WebMock.allow_net_connect!

# Checks for pending migrations before tests are run.
# ActiveRecord::Migration.check_pending!
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.mock_with :rspec
  config.include FactoryGirl::Syntax::Methods
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.treat_symbols_as_metadata_keys_with_true_values = true

  config.before(:all) { Sk.init('http://demo.salesking.local:3000', 'e72003cd56f54efb11ed8fdef282a633') }
end


def user_login(params = {})
  @request.session['access_token'] = params[:access_token] || 'abcdefg'
  @request.session['user_id']      = params[:user_id]      || 'some-user_id'
  @request.session['company_id']   = params[:company_id]   || 'a-company_id'
  @request.session['sub_domain']   = params[:sub_domain]   || 'my-subdomain'
end

def sk_config
  YAML.load_file(Rails.root.join('config', 'salesking_app.yml'))[Rails.env]
end

def sk_url(sub_domain)
  sk_config['sk_url'].gsub('*', sub_domain)
end

def canvas_slug
  sk_config['canvas_slug']
end

# Simulate a File Upload. Files reside in RAILS_ROOT/test/fixutes/files
# ==== Parameter
# filename<String>:: The file to upload
# ==== Returns
# <Object>::simulated file upload
def file_upload(filename)
  type = 'text/plain'
  file_path = Rails.root.join('spec/fixtures/', filename)
  Rack::Test::UploadedFile.new(file_path, type)
end

def data_rows_succeed_response
  content_type :json
  status response_code
  File.open(File.dirname(__FILE__) + '/fixtures/cassettes/Import/data_import' + 'creates_data_rows_and_succeeds', 'yml').read  
end

def response_to_json
  ActiveSupport::JSON.decode(response.body)
end
