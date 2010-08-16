include ../Makefile.defs

ROOTCA_CRT = ca.$(TOPLEVEL_DOMAIN).crt
ROOTCA_KEY = ca.$(TOPLEVEL_DOMAIN).key

all: $(ROOTCA_CRT) $(ROOTCA_KEY)

%.crt: %.key
	test ! -e $@
	openssl req -new -x509 -days 5479 -key $< -out $@ \
	  -subj '/CN=ca.$(TOPLEVEL_DOMAIN)/'
	chown root:www-data $@
	chmod 440 $@

%.key:
	test ! -e $@
	openssl genrsa -des3 -out $@ 4096
	chown root:root $@
	chmod 400 $@

# XXX remove before production
clean:
	rm -f $(ROOTCA_CRT) $(ROOTCA_KEY)
