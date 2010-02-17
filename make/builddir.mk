ifndef MKDIR
MKDIR = mkdir -p --
endif

ifndef builddir
builddir = build
endif
ifeq ($(builddir),)
$(warning "Empty builddir: defaulting to ./build")
builddir = build
endif

ifndef BUILDDIR_MK
BUILDDIR_MK = make/.builddir.mk
endif

ifndef BUILDDIR_CONF
BUILDDIR_CONF = $(builddir)/.build.mk
endif

ifndef BUILDDIR_HAVE_VAR
BUILDDIR_HAVE_VAR = HAVE_BUILDDIR
endif

ifndef INSTALL_DIR
INSTALL_DIR = install -d -m 0755
endif

distclean: clean confclean
confclean:
	$(call clean_p,$(BUILDDIR_MK))$(RM) $(BUILDDIR_MK)
	$(call clean_p,$(BUILDDIR_CONF))$(RM) $(BUILDDIR_CONF)
builddir_:
	$(call configure_p,builddir)
	@$(INSTALL_DIR) $(builddir)
	@echo '$(BUILDDIR_HAVE_VAR)=1' >> $(BUILDDIR_CONF)
.PHONY: distclean confclean builddir_

write_builddir_path = \
	@echo '$(1) = $($(1))' > $(BUILDDIR_MK)

