include ../Makefile.defs

ORGANISATIONS = $(shell cat LIST)

CA_DOMAINS = $(foreach org,$(ORGANISATIONS),ca.$(org).$(TOPLEVEL_DOMAIN))
CA_BUNDLES = $(addsuffix -bundle.pem,$(CA_DOMAINS))
CA_KEYS    = $(addsuffix .key,$(CA_DOMAINS))
CA_CRTS    = $(addsuffix .crt,$(CA_DOMAINS))

ROOTCA_CRT = ../rootca/ca.$(TOPLEVEL_DOMAIN).crt
ROOTCA_KEY = ../rootca/ca.$(TOPLEVEL_DOMAIN).key

ifdef ROOT_PASS
  ROOT_PASSIN    = -batch -passin pass:${ROOT_PASS}
endif

all: $(OPENSSL_INFRA) $(CA_BUNDLES) $(CA_CRTS) $(CA_KEYS)

%-bundle.pem: %.crt
	test ! -e $@
	cat $(ROOTCA_CRT) $< > $@
	chown root:root $@
	chmod 444 $@

%.crt: %.csr
	test ! -e $@
	openssl ca ${ROOT_PASSIN} $(OPENSSL_CONF) -out $@ -cert $(ROOTCA_CRT) \
	  -keyfile $(ROOTCA_KEY) -extensions v3_ca -notext -infiles $<
	chown root:root $@
	chmod 444 $@

%.csr: %.key
	test ! -e $@
	openssl req $(OPENSSL_CONF) -new -key $< -out $@ \
	  -subj '/CN=$(basename $@)/'
	chown root:root $@
	chmod 444 $@

%.key:
	test ! -e $@
	openssl genrsa -out $@ 4096
	chown root:www-data $@
	chmod 440 $@

# XXX remove before production!
clean:
	rm -f $(CA_BUNDLES) $(CA_KEYS) $(CA_CRTS)
	rm -rf workdir

include ../Makefile.targets
