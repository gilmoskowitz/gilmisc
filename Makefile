#
# make sure that every SUBDIR has a corresponding target below
SUBDIRS  = unclassified revisionControl shellAids
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
	mkdir -p $(HOME)/.vim/autoload
	-[ -f $(HOME)/.vim/autoload/pathogen.vim ] || \
	  curl -LSso $(HOME)/.vim/autoload/pathogen.vim \
	  https://tpo.pe/pathogen.vim
	mkdir -p $(HOME)/.vim/bundle
	-[ -d $(HOME)/.vim/bundle/syntastic ] || \
	  cd $(HOME)/.vim/bundle && \
	  git clone https://github.com/scrooloose/syntastic.git

$(SUBDIRS):
	$(MAKE) -$(MAKEFLAGS) -C $@
