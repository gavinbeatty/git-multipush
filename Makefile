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

default: all
.PHONY: default

.SUFFIXES:

PROJECT = git-multipush
-include gen-version.mk
-include dist.mk
-include man2txt.mk

clean: clean-doc clean-bin
.PHONY: clean

all: bin doc
.PHONY: all

install: install-bin install-doc
.PHONY: install

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
	$(call man2txt,doc/git-multipush.1,doc/git-multipush.txt)
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
		$(DESTDIR)$(prefix)/share/doc/git-multipush
	$(INSTALL) -m 0644 doc/git-multipush.txt \
		$(DESTDIR)$(prefix)/share/doc/git-multipush
	$(INSTALL) -m 0644 README.markdown \
		$(DESTDIR)$(prefix)/share/doc/git-multipush
.PHONY: install-doc

