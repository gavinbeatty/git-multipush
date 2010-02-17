prefix=/usr/local
DESTDIR=

PROJECT = git-multipush

bindir = $(DESTDIR)$(prefix)/bin
man1dir = $(DESTDIR)$(prefix)/share/man/man1
docdir = $(DESTDIR)$(prefix)/share/doc/$(PROJECT)

RM = rm -f
TAR = tar
ZIP = zip
INSTALL_DATA = install -m 0644
INSTALL_BIN = install -m 0755
INSTALL_DIR = install -d -m 0755
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

include make/pretty.mk
include make/builddir.mk
include make/gen-version.mk
include make/dist.mk
include make/man2txt.mk
-include make/.builddir.mk
-include $(builddir)/.build.mk

ifneq ($(HAVE_BUILDDIR),1)
all: conf
	$(make_p)$(MAKE) all
conf: builddir
	$(call write_builddir_path,builddir)
else
all: bin doc
endif
install: install-bin install-doc
clean:
	$(call clean_dir_p,$(builddir))
builddir_doc:
	@$(INSTALL_DIR) $(builddir)/doc
builddir: builddir_ builddir_doc
.PHONY: all conf install clean builddir builddir_doc

DOCS_DEP =
DOCS_DEP += doc/$(PROJECT).1.txt.in
DOCS_DEP += $(builddir)/doc/$(PROJECT).1.txt
DOCS_DEP += $(builddir)/doc/$(PROJECT).1.html
DOCS_DEP += $(builddir)/doc/$(PROJECT).1
DOCS_DEP += $(builddir)/doc/$(PROJECT).txt
DOCS_MAN1 =
DOCS_MAN1 += $(builddir)/doc/$(PROJECT).1.html
DOCS_MAN1 += $(builddir)/doc/$(PROJECT).1
DOCS_DOC =
DOCS_DOC += $(builddir)/doc/$(PROJECT).txt
DOCS_DOC += README.markdown
DOCS_INSTALL = $(DOCS_MAN1) $(DOCS_DOC)

$(builddir)/doc/$(PROJECT).1.txt: doc/$(PROJECT).1.txt.in $(VERSION_DEP)
	$(gen_p)$(SED) -e 's/^# @VERSION@/:man version: $(VERSION)/' $< > $@
$(builddir)/doc/$(PROJECT).1: $(builddir)/doc/$(PROJECT).1.txt
	$(a2x_p)$(A2X) -f manpage -L $<
$(builddir)/doc/$(PROJECT).1.html: $(builddir)/doc/$(PROJECT).1.txt
	$(asciidoc_p)$(ASCIIDOC) $<
$(builddir)/doc/$(PROJECT).txt: $(builddir)/doc/$(PROJECT).1
	$(roff_p)$(call man2txt,$<,$@)
doc: $(DOCS_DEP)
install-doc: $(DOCS_INSTALL)
	@$(INSTALL_DIR) $(man1dir)
	$(INSTALL_DATA) $(DOCS_MAN1) $(man1dir)
	@$(INSTALL_DIR) $(docdir)
	$(INSTALL_DATA) $(DOCS_DOC) $(docdir)
.PHONY: doc install-doc

BINS =
BINS += $(builddir)/$(PROJECT)
BINS_INSTALL = $(BINS)

$(builddir)/$(PROJECT): $(PROJECT).sh $(VERSION_DEP)
	$(gen_p)$(SED) -e 's/^# @VERSION@/VERSION=$(VERSION)/' $< > $@
	@chmod +x $(builddir)/$(PROJECT)
bin: $(BINS)
install-bin: $(BINS_INSTALL)
	@$(INSTALL_DIR) $(bindir)
	$(INSTALL_BIN) $(BINS_INSTALL) $(bindir)
.PHONY: bin install-bin


