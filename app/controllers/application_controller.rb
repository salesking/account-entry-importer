class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale

  rescue_from CanCan::AccessDenied do |exception|
    access_denied(exception.message)
  end

  protected

  def initialize_salesking_connection
    Sk::App.sub_domain = session['sub_domain']
    Sk.init(Sk::App.sk_api_url, session['access_token'])
  end

  def current_user
    user_id, company_id, access_token = session['user_id'], session['company_id'], session['access_token']
    if [user_id, company_id, access_token].all?(&:present?)
      @current_user ||= User.new(user_id: user_id, company_id: company_id)
    end
  end

  def access_denied(message)
    if session['sub_domain'] && Sk::App.sub_domain == session['sub_domain']
      render inline:  "<script> top.location.href='#{Sk::App.sk_url}'</script>"
    else
      redirect_to root_url, alert: message
    end
  end

  def set_locale
    gon['locale'] = I18n.locale = session['language']
  rescue I18n::InvalidLocale
    I18n.locale = I18n.default_locale
  end

  def gon
    @gon ||= {}
  end
  helper_method :gon
end
