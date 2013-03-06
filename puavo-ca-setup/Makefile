
prefix = /usr/local
exec_prefix = $(prefix)
sbindir = $(exec_prefix)/sbin

build:

install-dirs:
	mkdir -p $(DESTDIR)/etc
	mkdir -p $(DESTDIR)$(prefix)/bin
	mkdir -p $(DESTDIR)$(sbindir)

install: install-dirs
	cp -r etc/puavo-ca $(DESTDIR)/etc
	install -m 744 -t $(DESTDIR)$(sbindir) bin/puavo-gen-organisation-certs

clean:

