
# Puavo-CA Setup

    # puavo-ca-setup <topdomain>

You will be asked twice for a password to encrypt the root CA-certificate, and
twice again for a separate server CA-certificate (these should probably be
different).  Root CA-certificate is used to sign both the server CA-sertificate
and the organisation CA-certificates.  Server CA-certificate is used to sign
server certificates.

## Organisations

Edit `/etc/puavo-ca/organisations/LIST` to contain a list of organisations,
separated by newlines.

## Other servers

Puavo-CA server is already added here during `puavo-ca-setup`. Other servers
must be added manually.

Edit `/etc/puavo-ca/servers/SERVERLIST` to contain a list of servers, again
separated by newlines. Each server line may contain server aliases after the
certificate name. You may create the organisation certificates and server
certificates listed in those files with:

    # cd /etc/puavo-ca && make

You will be asked for the root CA key password (that you previously gave) once
for each organisation certificate and the server CA key password once for each
server certificate.

# Web app

You should also tell the web software the path to look for organisation
certificates by configuring in `<rails root>/config/puavo.yml` the parameter
`certdirpath` to point to `/etc/puavo-ca/organisations`.  Puavo-CA will use the
organisation certificates to sign the host certificate requests that are sent
to it.

