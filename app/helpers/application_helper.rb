module ApplicationHelper

  # http://stackoverflow.com/a/8552816/649555
  def cp(path)
    CURRENT if current_page?(path)
  end

  CURRENT = 'current'.freeze

  def icon(icon_link)
    "<i class=\"fa fa-#{icon_link}\"></i>".html_safe
  end

  def flash_class(level)
    case level
        when :notice then "alert alert-info"
        when :success then "alert alert-success"
        when :error then "alert alert-error"
        when :alert then "alert alert-error"
    end
  end

  def salesking_document_link(document_type, salesking_id)
    document_class = Sk.const_get(document_type.classify)
    sub_domain     = session[:sub_domain]

    uri_creator      = document_class.site.dup
    uri_creator.path = document_class.element_path(salesking_id, {}, {})

    url = uri_creator.to_s
    url.gsub!(document_class.format_extension, '') if document_class.format_extension.present?
    url.gsub!('api/', '')
    url
  end
end
