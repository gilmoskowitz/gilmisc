#
# make sure that every SUBDIR has a corresponding target below
SUBDIRS = unclassified revisionControl
FILES   = Dotvimrc

.PHONY: all install clean $(SUBDIRS)

all:	$(SUBDIRS)
	@echo Not much to do yet

install: $(SUBDIRS) $(FILES)
	cp Dotvimrc $(HOME)/.vimrc
	for D in $(SUBDIRS) ; do $(MAKE) -$(MAKEFLAGS) -C $$D $@ ; done

$(SUBDIRS):
	$(MAKE) -$(MAKEFLAGS) -C $@
