include ../Makefile.defs

ROOTCA_CRT = ca.$(TOPLEVEL_DOMAIN).crt
ROOTCA_KEY = ca.$(TOPLEVEL_DOMAIN).key

ifdef ROOT_PASS
  ROOT_PASSIN    = -passin pass:${ROOT_PASS}
  ROOT_PASSOUT   = -passout pass:${ROOT_PASS}
endif

all: $(ROOTCA_CRT) $(ROOTCA_KEY)

%.crt: %.key
	test ! -e $@
	openssl req ${ROOT_PASSIN} -new -x509 -days 5479 -sha512 -key $< \
	  -out $@ -subj '/CN=ca.$(TOPLEVEL_DOMAIN)/'
	chown root:puavo $@
	chmod 444 $@

%.key:
	test ! -e $@
	openssl genrsa ${ROOT_PASSOUT} -des3 -out $@ 4096
	chown root:root $@
	chmod 400 $@

# XXX remove before production
clean:
	rm -f $(ROOTCA_CRT) $(ROOTCA_KEY)
