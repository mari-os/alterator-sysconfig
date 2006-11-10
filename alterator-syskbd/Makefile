NAME=syskbd

INSTALL=/usr/bin/install

all:
clean: clean-po 
install: install-backend install-ui install-po install-data 

include /usr/share/alterator/build/po.mak
include /usr/share/alterator/build/ui2.mak
include /usr/share/alterator/build/backend.mak

install-data:
	$(INSTALL) -d $(sysconfdir)/alterator/xkb
	cp -a data $(sysconfdir)/alterator/xkb

