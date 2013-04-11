prefix = /usr/local
INSTALL_DIR = $(DESTDIR)$(prefix)/lib/puavo-ca-rails
BIN_DIR = $(DESTDIR)$(prefix)/bin
CONFIG_DIR = $(DESTDIR)$(prefix)/etc/puavo-ca

all: gems

mkdirs:
	mkdir -p $(INSTALL_DIR) $(BIN_DIR) $(CONFIG_DIR)

install: mkdirs
	echo "INSTALL_DIR=$(INSTALL_DIR)" > $(BIN_DIR)/puavo-ca-paths
	cp -r * $(INSTALL_DIR)
	rm $(INSTALL_DIR)/Gemfile*
	cp config/database.yml.example $(CONFIG_DIR)/database.yml
	cp config/puavo.yml.example $(CONFIG_DIR)/puavo.yml

gems:
	bundle install --standalone --binstubs

clean:
	rm -rf .bundle/ bin/ bundle/


