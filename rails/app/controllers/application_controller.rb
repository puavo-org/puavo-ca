class ApplicationController < ActionController::Base
  protect_from_forgery

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
  
  def organisation
    @organisation ||= params[:org] || nil
  end
end
