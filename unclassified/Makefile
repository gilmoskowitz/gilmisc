all:
	echo Nothing to do in `pwd`

install: backup		cntlines	collect_stats	copysnap	\
	 cvsbackup.pl	cvsgrew		diffcnt		findclass	\
	 gitnew		gitsync		grab 		graphBugs	\
	 grepsql	importmql.awk	include		inspr		\
	 isoToUSB.sh 							\
	 length		mismatch	recreatedb.sh	repeat		\
	 reverse	sdiffcvs	\
	 setenv2export	tailf		traceln		whence		\
	 xtindent
	if [ ! -d "$(HOME)/bin" ] ; then mkdir "$(HOME)/bin" ; fi
	install -b -C -S -v \
	 backup		cntlines	collect_stats	copysnap	\
	 cvsbackup.pl	cvsgrew		diffcnt		findclass	\
	 gitnew		gitsync		grab 		graphBugs	\
	 grepsql	importmql.awk	include		inspr		\
	 isoToUSB.sh 							\
	 length		mismatch	recreatedb.sh	repeat		\
	 reverse	sdiffcvs	\
	 setenv2export	tailf		traceln		whence		\
	 xtindent							\
	  "$(HOME)/bin"
	@if [ `ls $(HOME)/bin/*.old 2>/dev/null | wc -w` -le 0 ] ; then \
	   true								\
	 else								\
	   echo WARNING: review .old files in $(HOME)/bin ;		\
	 fi

