prefix = /usr/local
exec_prefix = $(prefix)
datarootdir = $(prefix)/share
sbindir = $(exec_prefix)/sbin

.PHONY: all
all:

.PHONY: install-dirs
install-dirs:
	mkdir -p $(DESTDIR)${datarootdir}/doc/puavo-ca/examples
	mkdir -p $(DESTDIR)${sbindir}

.PHONY: install
install: install-dirs
	cp -R certchain \
	      $(DESTDIR)${datarootdir}/doc/puavo-ca/examples/certchain
	install -o root -g root -m 755 \
		-t $(DESTDIR)$(sbindir) bin/puavo-make-new-ca-chain

.PHONY: clean
clean:
