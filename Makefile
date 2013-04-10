INSTALL_DIR = $(DESTDIR)$(prefix)/lib/puavo-ca-rails
BIN_DIR = $(DESTDIR)$(prefix)/bin

all: mkdirs gems install

mkdirs:
	mkdir -p $(INSTALL_DIR) $(BIN_DIR)

install:
	echo "INSTALL_DIR=$(INSTALL_DIR)" > $(BIN_DIR)/puavo-ca-paths
	rsync --archive --exclude=puavo-ca-setup * $(INSTALL_DIR)

gems:
	bundle install --deployment

