prefix=/usr/local
DESTDIR=

RM = rm -f
TAR = tar
ZIP = zip
INSTALL = install
GIT = git
BZIP2 = bzip2
ASCIIDOC = asciidoc
A2X = a2x
SED = sed
ROFF = groff

default: all
.PHONY: default

.SUFFIXES:

PROJECT = git-multipush
-include git-version.mk

clean: clean-doc clean-bin
.PHONY: clean
clean_: clean-doc clean-bin
.PHONY: clean_

all: bin doc
.PHONY: all

install: install-bin install-doc
.PHONY: install

TARNAME=git-multipush-$(VERSION)
dist: all VERSION
	@mkdir -p $(TARNAME)
	@echo VERSION=$(VERSION) > $(TARNAME)/release
	$(GIT) archive --format zip --prefix=$(TARNAME)/ \
	HEAD^{tree} --output $(TARNAME).zip
	@$(ZIP) -u $(TARNAME).zip $(TARNAME)/release >/dev/null
	$(GIT) archive --format tar --prefix=$(TARNAME)/ \
	HEAD^{tree} --output $(TARNAME).tar
	@$(TAR) rf $(TARNAME).tar $(TARNAME)/release
	@$(RM) -r $(TARNAME)
	$(BZIP2) -9 $(TARNAME).tar

# bin section
bin: git-multipush
.PHONY: bin
git-multipush: git-multipush.sh $(VERSION_DEP)
	$(SED) -e 's/^# @VERSION@/VERSION=$(VERSION)/' \
	git-multipush.sh > git-multipush
	@chmod +x git-multipush
clean-bin:
	$(RM) git-multipush
.PHONY: clean-bin

install-bin: bin
	$(INSTALL) -d -m 0755 $(DESTDIR)$(prefix)/bin
	$(INSTALL) -m 0755 git-multipush $(DESTDIR)$(prefix)/bin
.PHONY: install-bin


# doc section
doc: doc/git-multipush.1.txt \
	doc/git-multipush.1 \
	doc/git-multipush.1.html \
	doc/git-multipush.txt
.PHONY: doc
doc/git-multipush.1: doc/git-multipush.1.txt
	$(A2X) -f manpage -L doc/git-multipush.1.txt
doc/git-multipush.1.html: doc/git-multipush.1.txt
	$(ASCIIDOC) doc/git-multipush.1.txt
doc/git-multipush.txt: doc/git-multipush.1
	$(ROFF) -t -e -P -c -mandoc -Tutf8 doc/git-multipush.1 | col -bx \
	> doc/git-multipush.txt
clean-doc:
	$(RM) doc/git-multipush.1 doc/git-multipush.1.html doc/git-multipush.txt
.PHONY: clean-doc

install-doc: doc
	$(INSTALL) -d -m 0755 \
		$(DESTDIR)$(prefix)/share/man/man1
	$(INSTALL) -m 0644 doc/git-multipush.1 \
		$(DESTDIR)$(prefix)/share/man/man1
	$(INSTALL) -m 0644 doc/git-multipush.1.html \
		$(DESTDIR)$(prefix)/share/man/man1
	$(INSTALL) -d -m 0755 \
		$(DESTDIR)$(prefix)/share/doc/git-multipush/
	$(INSTALL) -m 0644 doc/git-multipush.txt \
		$(DESTDIR)$(prefix)/share/doc/git-multipush
.PHONY: install-doc

