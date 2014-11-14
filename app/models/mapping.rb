# Mapping is a container for a set of mapping elements
class Mapping < ActiveRecord::Base
  include UserReference

  # DOCUMENT_TYPES = %w(invoice order estimate credit_note).freeze
  IMPORT_TYPES   = %w(account account_entry).freeze
  has_many :attachments,      dependent: :nullify, inverse_of: :mapping
  has_many :mapping_elements, dependent: :destroy

  accepts_nested_attributes_for :mapping_elements

  validates :import_type,   inclusion: {in: IMPORT_TYPES  }
  # validates :document_type, inclusion: {in: DOCUMENT_TYPES}
  # Salesking UUID-s are always 22-chars long
  validates :account_id, format: {with: /\A[a-zA-Z0-9\-_]{22}\z/, allow_blank: true}
  validates :account_default_price, format: {with: /(?:^\d{1,3}(?:\.?\d{3})*(?:,\d{2})?$)|(?:^\d{1,3}(?:,?\d{3})*(?:\.\d{2})?$)/, allow_blank: true}
  validates :account_budget, format: {with: /(?:^\d{1,3}(?:\.?\d{3})*(?:,\d{2})?$)|(?:^\d{1,3}(?:,?\d{3})*(?:\.\d{2})?$)/, allow_blank: true}

  validates :mapping_elements, presence: true

  default_scope ->{order('mappings.id desc')} # should this be here?

  scope :by_company, lambda {|company_id| where(company_id: company_id)}
  scope :with_fields, -> {
    joins(:mapping_elements).
    select('mappings.id, mappings.account_id, mappings.account_name, mappings.account_default_price, mappings.account_budget, mappings.account_number, count(mapping_elements.id) as element_count').
    group('mappings.id')
  }

  def title
    I18n.t('mappings.title', count: mapping_elements.count, fields: mapping_elements.collect(&:target).to_sentence)
  end

end
