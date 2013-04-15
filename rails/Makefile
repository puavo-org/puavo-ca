prefix = /usr/local
sysconfdir = /etc
INSTALL_DIR = $(DESTDIR)/var/app/puavo-ca-rails
BIN_DIR = $(DESTDIR)$(prefix)/bin
CONFIG_DIR = $(DESTDIR)$(prefix)/share/puavo-ca-rails/config

all: gems

mkdirs:
	mkdir -p $(INSTALL_DIR) $(BIN_DIR) $(CONFIG_DIR)
	mkdir -p $(INSTALL_DIR)/tmp

install: mkdirs
	cp -r * .bundle $(INSTALL_DIR)
	cp config/database.yml.example $(CONFIG_DIR)/database.yml
	cp config/puavo.yml.example $(CONFIG_DIR)/puavo.yml

gems:
	bundle install --deployment

clean:
	rm -rf .bundle/ bin/ bundle/
