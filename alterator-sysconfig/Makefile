NAME=sysconfig

INSTALL=/usr/bin/install

all:
install: install-module install-data

include /usr/share/alterator/build/module.mak

install-data:
	$(INSTALL) -d $(sysconfdir)/alterator/sysconfig
	cp -a data/* $(sysconfdir)/alterator/sysconfig
	$(INSTALL) -d $(datadir)/install2
	cp -a preinstall.d $(datadir)/install2
