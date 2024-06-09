CMs := \
       ansible \
       cfengine \
       chef \
       puppet \
       #


.PHONY: all $(CMs)

all: $(CMs)

include cm/ansible/Makefile
include cm/cfengine/Makefile
include cm/chef/Makefile
include cm/puppet/Makefile
