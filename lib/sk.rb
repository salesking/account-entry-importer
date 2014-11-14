require 'sk_api_schema'
require 'sk_sdk/base'
require 'sk_sdk/oauth'
# Tiny helper class for talking to SalesKing
# - Setup local Sk:: classes for remote objects. contact, address,..
# - construct writable fields
class Sk
  # setup oAuth app info, local classes
  conf = YAML.load_file(Rails.root.join('config', 'salesking_app.yml'))
  App  = SK::SDK::Oauth.new(conf[Rails.env])

  Invoice    = Class.new(SK::SDK::Base)
  Order      = Class.new(SK::SDK::Base)
  Estimate   = Class.new(SK::SDK::Base)
  CreditNote = Class.new(SK::SDK::Base)

  Invoice::LineItem    = Class.new(SK::SDK::Base)
  Order::LineItem      = Class.new(SK::SDK::Base)
  Estimate::LineItem   = Class.new(SK::SDK::Base)
  CreditNote::LineItem = Class.new(SK::SDK::Base)

  Invoice::Item    = Class.new(SK::SDK::Base)
  Order::Item      = Class.new(SK::SDK::Base)
  Estimate::Item   = Class.new(SK::SDK::Base)
  CreditNote::Item = Class.new(SK::SDK::Base)

  Contact    = Class.new(SK::SDK::Base)
  Address    = Class.new(SK::SDK::Base)
  Account    = Class.new(SK::SDK::Base)
  AccountEntry   = Class.new(SK::SDK::Base)

  # init SalesKing classes and set connection oAuth token
  def self.init(site, token)
    (SK::SDK::Base.descendants + [SK::SDK::Base]).each do |base|
      base.set_connection(site: site, token: token)
    end
  end

  # read json-schema
  def self.read_schema(kind)
    SK::Api::Schema.read(kind, '1.0')
  end
end
