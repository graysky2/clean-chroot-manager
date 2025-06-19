VERSION = 2.240
PN = clean-chroot-manager

PREFIX ?= /usr
BASHCDIR = $(PREFIX)/share/bash-completion/completions
BINDIR = $(PREFIX)/bin
DOCDIR = $(PREFIX)/share/doc/$(PN)-$(VERSION)
MANDIR = $(PREFIX)/share/man/man1
SKELDIR = $(PREFIX)/share/$(PN)
ZSHCDIR = $(PREFIX)/share/zsh/site-functions
RM = rm -f
Q = @

all:
	$(Q)echo -e '\033[1;32mSetting version\033[0m'
	$(Q)sed 's/@VERSION@/'$(VERSION)'/' common/$(PN).in > common/$(PN)

install-bin:
	$(Q)echo -e '\033[1;32mInstalling main scripts and skel config...\033[0m'
	install -Dm755 common/$(PN) "$(DESTDIR)$(BINDIR)/$(PN)"
	ln -s $(PN) "$(DESTDIR)$(BINDIR)/ccm"
	install -Dm644 common/ccm.skel "$(DESTDIR)$(SKELDIR)/ccm.skel"

install-man:
	$(Q)echo -e '\033[1;32mInstalling manpage...\033[0m'
	install -Dm644 doc/$(PN).1 "$(DESTDIR)$(MANDIR)/$(PN).1"
	gzip -9 "$(DESTDIR)$(MANDIR)/$(PN).1"
	ln -s $(PN).1.gz "$(DESTDIR)$(MANDIR)/ccm.1.gz"
	install -Dm644 common/zsh-completion "$(DESTDIR)/$(ZSHCDIR)/_ccm"
	install -Dm644 common/bash-completion "$(DESTDIR)/$(BASHCDIR)/_ccm"

install: install-bin install-man

uninstall:
	$(Q)$(RM) "$(DESTDIR)$(BINDIR)/$(PN)"
	$(Q)$(RM) "$(DESTDIR)$(BINDIR)/ccm"
	$(Q)$(RM) "$(DESTDIR)$(BINDIR)/ccm"
	$(Q)$(RM) "$(DESTDIR)$(MANDIR)/$(PN).1.gz"
	$(Q)$(RM) "$(DESTDIR)$(MANDIR)/ccm.1.gz"
	$(Q)$(RM) -r "$(DESTDIR)$(SKELDIR)"
	$(Q)$(RM) "$(DESTDIR)/$(BASHCDIR)/_ccm"
	$(Q)$(RM) "$(DESTDIR)/$(ZSHCDIR)/_ccm"

clean:
	$(RM) common/$(PN)

.PHONY: help install-bin install-man install uninstall clean
