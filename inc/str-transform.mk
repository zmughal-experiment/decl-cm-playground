# str-transform-lc
define _shell-frag-compute-lc :=
perl -e 'print join $(DOLLAR)", map { lc } @ARGV'
endef
define str-transform-lc
$(call shell-with-check,$(_shell-frag-compute-lc) $(1))
endef

# str-transform-uc
define _shell-frag-compute-uc :=
perl -e 'print join $(DOLLAR)", map { uc } @ARGV'
endef
define str-transform-uc
$(call shell-with-check,$(_shell-frag-compute-uc) $(1))
endef

TEXT := HeY
#$(info $(call str-transform-lc,$(TEXT)))
#$(info $(call str-transform-uc,$(TEXT)))
