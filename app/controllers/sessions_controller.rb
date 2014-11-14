require 'sk_sdk/oauth'
require 'sk_sdk/signed_request'

class SessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  # POST Receives the oauth code from SalesKing, saves it to session
  # renders canvas haml
  def create
    signed_request = SK::SDK::SignedRequest.new(params[:signed_request], Sk::App.secret)
    raise "Invalid SalesKing app signed request #{signed_request.data.inspect}" unless signed_request.valid?

    # always save and set subdomain
    Sk::App.sub_domain = session['sub_domain'] = signed_request.data['sub_domain']

    if signed_request.data['user_id'] # logged in
      session['language'] = find_locale(signed_request.data['language'])

      allowed_keys        = %w(access_token user_id company_id)
      session.merge!(signed_request.data.reject {|key,_| !allowed_keys.include?(key) })

      redirect_to attachments_url
    else # must authorize redirect to oauth dialog
      render inline: "<script> top.location.href='#{Sk::App.auth_dialog}'</script>"
    end
  end

  #GET coming back from auth dialog as redirect_url
  def new
    code = params[:code]
    if code.present? # coming back from auth dialog as redirect_url
      Sk::App.sub_domain = session['sub_domain']
      Sk::App.get_token(code)
      #redirect to sk internal canvas page, where we are now authenticated
      render inline: "<script> top.location.href='#{Sk::App.sk_canvas_url}'</script>"
    end
  end

  private

  def find_locale(locale)
    locale.match(/\A(?<country>[a-z]{2})_[A-Z]{2}\Z/).try(:[], :country) || locale
  end
end
