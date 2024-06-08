CMs := \
       ansible \
       cfengine \
       #


.PHONY: all $(CMs)

all: $(CMs)

include cm/ansible/Makefile
include cm/cfengine/Makefile
