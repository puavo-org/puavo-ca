prefix = /usr/local
sysconfdir = /etc
INSTALL_DIR = $(DESTDIR)/var/app/puavo-ca-rails
BIN_DIR = $(DESTDIR)$(prefix)/bin
CONF_DIR = $(DESTDIR)$(sysconfdir)/puavo-ca-rails
RAILS_CONFIG_DIR = $(INSTALL_DIR)/config

.PHONY: all
all: gems

.PHONY: update-gemfile-lock
update-gemfile-lock: clean
	rm -f Gemfile.lock
	GEM_HOME=.tmpgem bundle install
	rm -rf .tmpgem
	bundle install --deployment

.PHONY: mkdirs
mkdirs:
	mkdir -p $(INSTALL_DIR) $(BIN_DIR) $(RAILS_CONFIG_DIR) $(CONF_DIR)
	mkdir -p $(INSTALL_DIR)/tmp

.PHONY: install
install: mkdirs
	cp -r * .bundle $(INSTALL_DIR)
	cp config/database.yml.example $(CONF_DIR)/database.yml
	cp config/puavo.yml.example $(CONF_DIR)/puavo.yml
	ln -s ../../../../etc/puavo-ca-rails/database.yml $(RAILS_CONFIG_DIR)/database.yml
	ln -s ../../../../etc/puavo-ca-rails/puavo.yml $(RAILS_CONFIG_DIR)/puavo.yml

.PHONY: gems
gems:
	bundle install --deployment

.PHONY: server
server:
	bundle exec rails server -b 0.0.0.0 -p 8080

.PHONY: clean
clean:
	rm -rf .bundle/ bin/ bundle/
