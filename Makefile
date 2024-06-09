CMs := \
       ansible \
       cfengine \
       puppet \
       #


.PHONY: all $(CMs)

all: $(CMs)

include cm/ansible/Makefile
include cm/cfengine/Makefile
include cm/puppet/Makefile
