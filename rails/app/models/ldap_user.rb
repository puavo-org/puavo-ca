require 'ldap'

class LdapUser
  def self.authenticate(dn, password)
    logger.debug "Ldap Authentication with dn: #{ dn }"

    begin
      ldap = LDAP::Conn.new(host=PUAVO_CONFIG['ldap_server'])
      ldap.set_option(LDAP::LDAP_OPT_PROTOCOL_VERSION, 3)
      ldap.start_tls
      return true if ldap.bind(dn, password)
    rescue StandardError => e
      logger.info "Authentication failed: #{ e.message }"
    end

    return false
  end

  private

  def self.logger
    Rails.logger
  end
end
