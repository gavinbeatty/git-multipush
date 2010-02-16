prefix=/usr/local
DESTDIR=

RM = rm -f
TAR = tar
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
GIT-MULTIPUSH-VERSION: gen-version.sh .git/$(shell git symbolic-ref HEAD)
	@gen-version.sh git-multipush GIT_MULTIPUSH_VERSION GIT-MULTIPUSH-VERSION \
	--tags
-include GIT-MULTIPUSH-VERSION
clean-version:
	$(RM) GIT-MULTIPUSH-VERSION

clean: clean-doc clean-bin clean-version
.PHONY: clean
clean_: clean-doc clean-bin
.PHONY: clean_

all: bin doc
.PHONY: all

install: install-bin install-doc
.PHONY: install


# bin section
bin: git-multipush
.PHONY: bin
git-multipush: git-multipush.sh GIT-MULTIPUSH-VERSION
	$(SED) -e 's/^# @GIT_MULTIPUSH_VERSION@/GIT_MULTIPUSH_VERSION=$(GIT_MULTIPUSH_VERSION)/' \
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
		$(DESTDIR)$(prefix)/share/man/man1/
	$(INSTALL) -m 0644 doc/git-multipush.1.html \
		$(DESTDIR)$(prefix)/share/man/man1/
	$(INSTALL) -d -m 0755 \
		$(DESTDIR)$(prefix)/share/doc/git-multipush/
	$(INSTALL) -m 0644 doc/git-multipush.txt \
		$(DESTDIR)$(prefix)/share/doc/git-multipush/
.PHONY: install-doc

