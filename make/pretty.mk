PRETTY_MK_INCLUDED=1

ifndef VERBOSE
# 'macros'
asciidoc_p =    @echo '    ASCIIDOC  ' $@;
a2x_p =         @echo '    A2X       ' $@;
roff_p =        @echo '    ROFF      ' $@;
gen_p =         @echo '    GEN       ' $@;
make_p =        @echo '    MAKE      ' $@;

# functions
clean_dir_p =   @echo '    CLEAN     ' $(1)/;
clean_p =       @echo '    CLEAN     ' $(1);
configure_p =   @echo '    CONFIGURE  $(1)=$($(1))';
endif

