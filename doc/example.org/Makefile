SUBDIRS = rootca servers organisations

all: $(SUBDIRS)

$(SUBDIRS)::
	(cd $@ && $(MAKE))

# XXX remove before production
clean:
	for subdir in $(SUBDIRS); do (cd $$subdir && $(MAKE) clean); done
