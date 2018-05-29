VERSION = 2.89
PN = clean-chroot-manager

PREFIX ?= /usr
BINDIR = $(PREFIX)/bin
DOCDIR = $(PREFIX)/share/doc/$(PN)-$(VERSION)
MANDIR = $(PREFIX)/share/man/man1
SKELDIR = $(PREFIX)/share/$(PN)
ZSHDIR = $(PREFIX)/share/zsh/site-functions
RM = rm -f
Q = @

all:
	$(Q)echo -e '\033[1;32mSetting version\033[0m'
	$(Q)sed 's/@VERSION@/'$(VERSION)'/' common/$(PN)64.in > common/$(PN)64

install-bin:
	$(Q)echo -e '\033[1;32mInstalling main scripts and skel config...\033[0m'
	install -Dm755 common/$(PN)64 "$(DESTDIR)$(BINDIR)/$(PN)64"
	# default is to run in 64-bit mode so make shortcut without suffix
	ln -s $(PN)64 "$(DESTDIR)$(BINDIR)/ccm"
	# failsafe is to make a ccm64 and ccm32 for each build mode
	ln -s $(PN)64 "$(DESTDIR)$(BINDIR)/ccm64"
	install -Dm644 common/ccm.skel "$(DESTDIR)$(SKELDIR)/ccm.skel"
	install -d "$(DESTDIR)$(ZSHDIR)"
	install -m644  common/zsh-completion "$(DESTDIR)/$(ZSHDIR)/_ccm"

install-man:
	$(Q)echo -e '\033[1;32mInstalling manpage...\033[0m'
	install -Dm644 doc/$(PN).1 "$(DESTDIR)$(MANDIR)/$(PN).1"
	gzip -9 "$(DESTDIR)$(MANDIR)/$(PN).1"
	ln -s $(PN).1.gz "$(DESTDIR)$(MANDIR)/ccm.1.gz"

install: install-bin install-man

uninstall:
	$(Q)$(RM) "$(DESTDIR)$(BINDIR)/$(PN)64"
	$(Q)$(RM) "$(DESTDIR)$(BINDIR)/ccm64"
	$(Q)$(RM) "$(DESTDIR)$(BINDIR)/ccm"
	$(Q)$(RM) "$(DESTDIR)$(MANDIR)/$(PN).1.gz"
	$(Q)$(RM) -r "$(DESTDIR)$(SKELDIR)"
	$(Q)$(RM) "$(DESTDIR)/$(ZSHDIR)/_ccm"

clean:
	$(RM) common/$(PN)64

.PHONY: help install-bin install-man install uninstall clean
