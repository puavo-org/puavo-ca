prefix = /usr/local
INSTALL_DIR = $(DESTDIR)$(prefix)/lib/puavo-ca-rails
BIN_DIR = $(DESTDIR)$(prefix)/bin

all: gems

mkdirs:
	mkdir -p $(INSTALL_DIR) $(BIN_DIR)

install: mkdirs
	echo "INSTALL_DIR=$(INSTALL_DIR)" > $(BIN_DIR)/puavo-ca-paths
	cp -r * .bundle $(INSTALL_DIR)
	rm -rf $(INSTALL_DIR)/puavo-ca-setup

gems:
	bundle install --standalone

