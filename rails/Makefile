prefix = /usr/local
sysconfdir = /etc
INSTALL_DIR = $(DESTDIR)/var/app/puavo-ca-rails
BIN_DIR = $(DESTDIR)$(prefix)/bin
CONF_DIR = $(DESTDIR)$(sysconfdir)/puavo-ca-rails
RAILS_CONFIG_DIR = $(INSTALL_DIR)/config

all: gems

mkdirs:
	mkdir -p $(INSTALL_DIR) $(BIN_DIR) $(RAILS_CONFIG_DIR) $(CONF_DIR)
	mkdir -p $(INSTALL_DIR)/tmp

install: mkdirs
	cp -r * .bundle $(INSTALL_DIR)
	cp config/database.yml.example $(CONF_DIR)/database.yml
	cp config/puavo.yml.example $(CONF_DIR)/puavo.yml
	ln -s $(CONF_DIR)/database.yml $(RAILS_CONFIG_DIR)/database.yml
	ln -s $(CONF_DIR)/puavo.yml $(RAILS_CONFIG_DIR)/puavo.yml

gems:
	bundle install --deployment

clean:
	rm -rf .bundle/ bin/ bundle/
