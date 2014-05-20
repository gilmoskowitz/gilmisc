# make sure that every SUBDIR has a corresponding target below
SUBDIRS = unclassified
all:	$(SUBDIRS)
	@echo Not much to do yet

install: $(SUBDIRS)

unclassified: FORCE
	cd unclassified && $(MAKE)	# TODO: how do we pass 'install' target?

FORCE:
