class LdapUser
  def self.authenticate(dn, password)
    logger.debug "Ldap Authentication:"
    logger.debug "dn: #{dn}"

    begin
      ldap = LDAP::Conn.new(host=PUAVO_CONFIG['ldap_server'])
      ldap.set_option(LDAP::LDAP_OPT_PROTOCOL_VERSION, 3)
      ldap.start_tls
      return true if ldap.bind(dn, password)

      # FIXME:  Allow authetication only if user is School Admin in the some School or organisation owner.
    rescue Exception => e
      logger.info "Authentication failed, Exception: #{e}"
      return false
    end
  end

  private

  def self.logger
    Rails.logger
  end
end
