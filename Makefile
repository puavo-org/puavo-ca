subdirs = setup rails
install-subdirs = $(subdirs:%=install-%)
clean-subdirs = $(subdirs:%=clean-%)

.PHONY: all
all: $(subdirs)

.PHONY: $(subdirs)
$(subdirs):
	$(MAKE) -C $@

.PHONY: $(install-subdirs)
$(install-subdirs):
	$(MAKE) -C $(@:install-%=%) install

.PHONY: install
install: $(install-subdirs)

.PHONY: $(clean-subdirs)
$(clean-subdirs):
	$(MAKE) -C $(@:clean-%=%) clean

.PHONY: test
	@echo tests not implemented yet

.PHONY: clean
clean: $(clean-subdirs)

.PHONY: deb
deb:
	cp -p debian/changelog.vc debian/changelog 2>/dev/null \
	  || cp -p debian/changelog debian/changelog.vc
	dch --newversion \
	    "$$(cat VERSION)+build$$(date +%s)+$$(git rev-parse HEAD)" \
	    "Built from $$(git rev-parse HEAD)"
	dch --release ''
	dpkg-buildpackage -us -uc
	cp -p debian/changelog.vc debian/changelog

.PHONY: install-build-deps
install-build-deps:
	mk-build-deps --install --tool 'apt-get --yes' --remove debian/control

.PHONY: upload-deb
upload-deb:
	dput puavo ../puavo-ca_*.changes
