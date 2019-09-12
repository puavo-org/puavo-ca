class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception,
    unless: Proc.new { |c| c.request.format.json? || c.request.format.xml? }

  before_action :require_http_auth_user

  private

  def require_http_auth_user
    unless authenticate_with_http_basic do |dn, password|
        session[:dn] = dn
        LdapUser.authenticate(dn, password)
      end
      render :json => "401 Unauthorized.", :status => :unauthorized
    end
  end
end
