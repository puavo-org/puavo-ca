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
	@echo Not implemented yet
	@exit 1

.PHONY: clean
clean: $(clean-subdirs)
