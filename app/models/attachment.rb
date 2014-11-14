# encoding: utf-8

# Store uploaded files, temporary until the import is created
#
# If files need to present afterwards should implement persistent s3 storage!!

require 'csv'

class Attachment < ActiveRecord::Base

  include UserReference

  belongs_to :mapping, inverse_of: :attachments
  has_many :imports, dependent: :destroy, inverse_of: :attachment

  default_scope ->{ order('attachments.id desc') }

  after_create  :store_file
  after_destroy :delete_file

  validates :filename, :disk_filename, :quote_character, :encoding, presence: true
  validate :column_separator_presence

  #attr_accessible :column_separator, :quote_character, :uploaded_data, :encoding, :mapping_id
  attr_reader :error_rows

  def column_separator=(original_value)
    self.send(:write_attribute, :column_separator, original_value == "\\t" ? "\t" : original_value)
  end

  # Any upload file gets passed in as uploaded_data attribute
  # Here its beeing parsed into its bits and pieces so the other attributes can
  # be set (filesize / filename / ..)
  # Sets instance var @uploaded_file, which points to a temp file object and is
  # stored to its final destination after save

  def uploaded_data=(data)
    return unless data.present?
    #set new values
    self.filename = data.original_filename.strip.gsub(/[^\w\d\.\-]+/, '_')

    #%L milliseconds 000-999
    used_disk_filename = Time.zone.now.strftime('%y%m%d%H%M%S%L_')
    if filename =~ /^[a-zA-Z0-9_\.\-]*$/
      used_disk_filename << filename
    else
      used_disk_filename << Digest::MD5.hexdigest(filename)
      used_disk_filename << File.extname(filename)
    end
    self.disk_filename = used_disk_filename

    #check for small files indicated by beeing a StringIO
    @uploaded_file = data
  end

  # full path with filename
  def full_filename
    File.join(Rails.root, 'tmp', 'attachments', self.disk_filename)
  end

  def rows(size = 0)
    parsed_data[0..(size - 1)]
  end

  private

  # When parsing data, we expect our file to be saved as valid utf-8
  # TODO rescue parser errors -> rows empty
  def parsed_data
    @parsed_data ||= begin
      CSV.read(full_filename, col_sep: column_separator, quote_char: quote_character, encoding: encoding)
    rescue #CSV::MalformedCSVError => er
      rows = []
      #one more attempt. If BOM is present in the file.
      begin
        file = File.open(full_filename, 'rb:bom|utf-8')
        rows = CSV.parse(file.read.force_encoding('ISO-8859-1'))
      ensure
        return rows
      end
    end
  end

  # store the uploaded tempfile.
  def store_file
    # TODO
    # - kick BOM if present
    # - convert to UTF-8 if a different encoding is given
    # - we should check double encoding because the tempfile is always read as utf8

    # writes the file binary/raw without taking encodings into account.
    # If we want to convert incoming files this should be done before
    File.open(full_filename, 'wb') do |f| #w:UTF-8
      f.write @uploaded_file.read
    end
  end

  def delete_file
    File.delete(full_filename) rescue true #catch Errno::ENOENT exception for deleted files
  end

  def column_separator_presence
    (self.column_separator.present? || self.column_separator == "\t" ) || self.errors.add(:column_separator, :must_be_present)
  end
end
