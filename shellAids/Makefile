PROGS =	div

.PHONY: all install clean $(SUBDIRS)

all:
	@echo build finished in `pwd`

install: $(PROGS)
	[ -d "$(HOME)/bin" ] || mkdir "$(HOME)/bin"
	install -b -C -S -v $(PROGS) "$(HOME)/bin"
	@if [ `ls $(HOME)/bin/*.old 2>/dev/null | wc -w` -le 0 ] ; then \
	   true								\
	 else								\
	   echo WARNING: review .old files in $(HOME)/bin ;		\
	 fi

clean:
	@echo nothing to clean
