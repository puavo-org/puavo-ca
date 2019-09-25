require 'net/ldap'

class LdapUser
  def self.authenticate_and_get_user(dn, password)
    logger.debug "Ldap Authentication with dn: #{ dn }"

    return nil if password == ''

    begin
      ldap = Net::LDAP.new(:host => PUAVO_CONFIG['ldap_server'],
                           :auth => {
                             :method   => :simple,
                             :username => dn,
                             :password => password,
                           },
                           :encryption => {
                             :method => :start_tls,
                             :tls_options => {
                               :verify_mode => OpenSSL::SSL::VERIFY_NONE,
                             }
                           })

      user_info = ldap.search(:base => dn)
      return nil unless user_info && user_info.count == 1

      return user_info.first
    rescue StandardError => e
      logger.info "Authentication failed: #{ e.message }"
    end

    return nil
  end

  private

  def self.logger
    Rails.logger
  end
end
