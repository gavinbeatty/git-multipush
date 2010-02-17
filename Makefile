prefix=/usr/local
DESTDIR=

PROJECT = git-multipush

bindir = $(DESTDIR)$(prefix)/bin
man1dir = $(DESTDIR)$(prefix)/share/man/man1
docdir = $(DESTDIR)$(prefix)/share/doc/$(PROJECT)

RM = rm -f
TAR = tar
ZIP = zip
INSTALL_DIR = install -d -m 0755
INSTALL_BIN = install -m 0755
INSTALL_DATA = install -m 0644
GIT = git
BZIP2 = bzip2
ASCIIDOC = asciidoc
A2X = a2x
SED = sed
MKDIR = mkdir -p --
TOUCH = touch

default: all
.PHONY: default

.SUFFIXES:

include make/builddir.mk
include make/gen-version.mk
include make/dist.mk
include make/man2txt.mk
-include make/.builddir.mk
-include $(builddir)/.build.mk

ifneq ($(HAVE_BUILDDIR),1)
all: builddir
	$(call write_builddir_path,builddir)
	@echo 'Now `make` again.'
else
all: bin doc
endif
install: install-bin install-doc
clean:
	$(RM) -r $(builddir)
builddir_doc:
	$(INSTALL_DIR) $(builddir)/doc
builddir: builddir_ builddir_doc
.PHONY: all install clean builddir builddir_doc

DOCS =
DOCS += $(builddir)/doc/$(PROJECT).1.txt
DOCS += $(builddir)/doc/$(PROJECT).1
DOCS += $(builddir)/doc/$(PROJECT).1.html
DOCS += $(builddir)/doc/$(PROJECT).txt
DOCS_INSTALL = $(DOCS)
DOCS_INSTALL += README.markdown

$(builddir)/doc/$(PROJECT).1.txt: doc/$(PROJECT).1.txt.in $(VERSION_DEP)
	$(SED) -e 's/^# @VERSION@/:man version: $(VERSION)/' doc/$(PROJECT).1.txt.in \
	> $(builddir)/doc/$(PROJECT).1.txt
$(builddir)/doc/$(PROJECT).1: $(builddir)/doc/$(PROJECT).1.txt
	$(A2X) -f manpage -L $(builddir)/doc/$(PROJECT).1.txt
$(builddir)/doc/$(PROJECT).1.html: $(builddir)/doc/$(PROJECT).1.txt
	$(ASCIIDOC) $(builddir)/doc/$(PROJECT).1.txt
$(builddir)/doc/$(PROJECT).txt: $(builddir)/doc/$(PROJECT).1
	$(call man2txt,$(builddir)/doc/$(PROJECT).1,$(builddir)/doc/$(PROJECT).txt)
doc: $(DOCS)
install-doc: $(DOCS_INSTALL)
	$(INSTALL_DIR) $(man1dir)
	$(INSTALL_DATA) $(builddir)/doc/$(PROJECT).1 $(man1dir)
	$(INSTALL_DATA) $(builddir)/doc/$(PROJECT).1.html $(man1dir)
	$(INSTALL_DIR) $(docdir)
	$(INSTALL_DATA) $(builddir)/doc/$(PROJECT).txt $(docdir)
	$(INSTALL_DATA) README.markdown $(docdir)
.PHONY: doc install-doc

BINS =
BINS += $(builddir)/$(PROJECT)
BINS_INSTALL = $(BINS)

$(builddir)/$(PROJECT): $(PROJECT).sh $(VERSION_DEP)
	$(SED) -e 's/^# @VERSION@/VERSION=$(VERSION)/' $(PROJECT).sh \
	> $(builddir)/$(PROJECT)
	@chmod +x $(builddir)/$(PROJECT)
bin: $(BINS)
install-bin: $(BINS_INSTALL)
	$(INSTALL_DIR) $(bindir)
	$(INSTALL_BIN) $(builddir)/$(PROJECT) $(bindir)
.PHONY: bin install-bin


