VERSION = 2.20
PN = clean-chroot-manager

PREFIX ?= /usr
BINDIR = $(PREFIX)/bin
DOCDIR = $(PREFIX)/share/doc/$(PN)-$(VERSION)
MANDIR = $(PREFIX)/share/man/man1
SKELDIR = $(PREFIX)/share/$(PN)
RM = rm
Q = @

all:
	$(Q)echo -e '\033[1;32mSetting version\033[0m'
	$(Q)sed 's/@VERSION@/'$(VERSION)'/' common/$(PN).in > common/$(PN)

install-bin:
	$(Q)echo -e '\033[1;32mInstalling main script and skel config...\033[0m'
	install -Dm755 common/$(PN) "$(DESTDIR)$(BINDIR)/$(PN)"
	install -Dm644 common/ccm.skel "$(DESTDIR)$(SKELDIR)/ccm.skel"
	ln -s $(PN) "$(DESTDIR)$(BINDIR)/ccm"

install-man:
	$(Q)echo -e '\033[1;32mInstalling manpage...\033[0m'
	install -Dm644 doc/$(PN).1 "$(DESTDIR)$(MANDIR)/$(PN).1"
	gzip -9 "$(DESTDIR)$(MANDIR)/$(PN).1"
	ln -s $(PN).1.gz "$(DESTDIR)$(MANDIR)/ccm.1.gz"

install: install-bin install-man

uninstall:
	$(Q)$(RM) "$(DESTDIR)$(BINDIR)/$(PN)"
	$(Q)$(RM) "$(DESTDIR)$(MANDIR)/$(PN).1.gz"
	$(Q)$(RM) -rf "$(DESTDIR)$(SKELDIR)"
