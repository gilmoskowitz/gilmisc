PROGS =  cvsbackup.pl	cvsgrew		diffcnt		sdiffcvs        \
	 gitnew		gitsync

.PHONY: all install clean $(SUBDIRS)

all:    $(PROGS)
	@echo build finished in `pwd`

install: $(PROGS)
	[ -d "$(HOME)/bin" ] || "$(HOME)/bin"
	install -b -C -S -v $(PROGS) "$(HOME)/bin"
	@if [ `ls $(HOME)/bin/*.old 2>/dev/null | wc -w` -le 0 ] ; then \
	   true								\
	 else								\
	   echo WARNING: review .old files in $(HOME)/bin ;		\
	 fi

