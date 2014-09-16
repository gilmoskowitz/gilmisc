#
# make sure that every SUBDIR has a corresponding target below
SUBDIRS  = unclassified revisionControl
DOTFILES = Dotvimrc Dotbashrc Dotbash_profile
FILES    = $(DOTFILES)

.PHONY: all imports install clean $(SUBDIRS)

all:	$(SUBDIRS)
	@echo Not much to do yet

install: $(SUBDIRS) $(FILES)
	for DOT in $(DOTFILES) ; do \
	  cp $$DOT $(HOME)/`basename $$DOT | sed -e "s/Dot/./"` ; \
	done
	for DIR in $(SUBDIRS) ; do $(MAKE) -$(MAKEFLAGS) -C $$DIR $@ ; done

$(SUBDIRS):
	$(MAKE) -$(MAKEFLAGS) -C $@
