
ifndef GIT
GIT = git
endif
ifndef RM
RM = rm -f
endif
ifndef PROJECT_VERSION_VAR
PROJECT_VERSION_VAR = VERSION
endif
ifndef PROJECT_RELEASE_FILE
PROJECT_RELEASE_FILE = release
endif
ifndef GEN_VERSION_SH
GEN_VERSION_SH = make/gen-version.sh
endif

-include $(PROJECT_RELEASE_FILE)
ifeq ($(strip $($(PROJECT_VERSION_VAR))),)
$(PROJECT_VERSION_VAR)_DEP=$(PROJECT_VERSION_VAR)
$(PROJECT_VERSION_VAR): $(GEN_VERSION_SH) .git/$(shell $(GIT) symbolic-ref HEAD)
	@$(GEN_VERSION_SH) $(PROJECT) $(PROJECT_VERSION_VAR) $(PROJECT_VERSION_VAR)
-include $(PROJECT_VERSION_VAR)
else
$(PROJECT_VERSION_VAR)_DEP=
endif
clean-version:
	$(call clean_p,$(PROJECT_VERSION_VAR))$(RM) $(PROJECT_VERSION_VAR)
clean: clean-version

