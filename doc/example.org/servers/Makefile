include ../Makefile.defs

SERVER_NAMES = $(shell cat LIST)

SERVERS        = $(addsuffix .$(TOPLEVEL_DOMAIN),$(SERVER_NAMES))
# SERVER_BUNDLES = $(addsuffix -bundle.pem,$(SERVERS))
SERVER_KEYS    = $(addsuffix .key,$(SERVERS))
SERVER_CSRS    = $(addsuffix .csr,$(SERVERS))
SERVER_CRTS    = $(addsuffix .crt,$(SERVERS))

ROOTCA_CRT = ../rootca/ca.$(TOPLEVEL_DOMAIN).crt
ROOTCA_KEY = ../rootca/ca.$(TOPLEVEL_DOMAIN).key

SUBCA_DOMAIN = ca.servers.$(TOPLEVEL_DOMAIN)
SUBCA_CRT    = $(SUBCA_DOMAIN).crt
SUBCA_CSR    = $(SUBCA_DOMAIN).csr
SUBCA_KEY    = $(SUBCA_DOMAIN).key

.INTERMEDIATE: $(SUBCA_CSR)

all: $(OPENSSL_INFRA) $(SUBCA_CRT) $(SUBCA_KEY) $(SERVER_CRTS) $(SERVER_KEYS)

%.crt: %.csr
	test ! -e $@
	openssl ca $(OPENSSL_CONF) -out $@ -cert $(SUBCA_CRT) \
	  -keyfile $(SUBCA_KEY) -notext -infiles $<
	chown root:root $@
	chmod 444 $@

%.csr: %.key
	test ! -e $@
	openssl req $(OPENSSL_CONF) -new -key $< -out $@ \
	  -subj '/CN=$(subst wildcard.,*.,$(basename $@))/'
	chown root:root $@
	chmod 444 $@

%.key:
	test ! -e $@
	openssl genrsa -out $@ 4096
	chown root:root $@
	chmod 400 $@

$(SUBCA_CRT): $(SUBCA_CSR)
	test ! -e $@
	openssl ca $(OPENSSL_CONF) -out $@ -cert $(ROOTCA_CRT) \
	  -keyfile $(ROOTCA_KEY) -extensions v3_ca -notext -infiles $<
	chown root:root $@
	chmod 444 $@

$(SUBCA_CSR): $(SUBCA_KEY)
	test ! -e $@
	openssl req $(OPENSSL_CONF) -new -key $< -out $@ \
	  -subj '/CN=$(basename $@)/'
	chown root:root $@
	chmod 444 $@

$(SUBCA_KEY):
	test ! -e $@
	openssl genrsa -des3 -out $@ 4096
	chown root:root $@
	chmod 400 $@

# XXX remove before production!
clean:
	rm -f $(SERVER_CRTS) $(SERVER_KEYS) $(SUBCA_CRT) $(SUBCA_KEY)
	rm -rf workdir

include ../Makefile.targets
