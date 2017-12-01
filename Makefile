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

.PHONY: deb
deb:
	[ -e debian/changelog.orig ] \
	  || cp -p debian/changelog debian/changelog.orig
	dch --newversion "$$(cat VERSION)+build$$(date +%s)+$$(git rev-parse HEAD)" "Built from $$(git rev-parse HEAD)"
	dpkg-buildpackage -us -uc

.PHONY: clean
clean: $(clean-subdirs)
