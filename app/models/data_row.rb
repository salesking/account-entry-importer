class DataRow < ActiveRecord::Base
  belongs_to :import

  attr_writer :data

  scope :failed,  -> {where(external_id: nil)}
  scope :success, -> {where('data_rows.external_id IS NOT NULL')}

  protected

  def mapping_element_assignment(object, row)
    Proc.new do |mapping_element|
      value = mapping_element.convert(row)
      object.send("#{mapping_element.target}=", value)
    end
  end

  def imported_class
    @imported_class ||= Sk.const_get(mapping.import_type.classify)
  end

  def mapping
    @mapping ||= self.import.attachment.mapping
  end
end
