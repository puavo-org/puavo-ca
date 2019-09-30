PUAVO_CONFIG = YAML.load_file("#{Rails.root}/config/puavo.yml")

if PUAVO_CONFIG["ldap_server"].to_s.empty?
  require "puavo/etc"
  PUAVO_CONFIG["ldap_server"] = PUAVO_ETC.ldap_master
end
