class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception,
    unless: Proc.new { |c| c.request.format.json? || c.request.format.xml? }

  before_action :require_http_auth_user

  rescue_from StandardError do |e|
    render :json   => { :error => e.message },
           :status => 500
  end

  private

  def require_http_auth_user
    user = authenticate_with_http_basic do |dn, password|
             session[:dn] = dn
             LdapUser.authenticate_and_get_user(dn, password)
           end

    @client_fqdn = nil

    unless user && Array(user['objectclass']).include?('device') then
      return render :json   => { :error => 'no permission (bad user)' },
                    :status => :unauthorized
    end

    hostname = Array(user['cn']).first
    # "parentnode" is a bit strange attribute name, but that is what
    # we currently have (it is always set to puavoDomain).
    domain = Array(user['parentnode']).first
    @client_fqdn = "#{ hostname }.#{ domain }"
    return true
  end
end
