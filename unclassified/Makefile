all:
	echo Nothing to do in `pwd`

install: backup		cntlines	collect_stats	copysnap	\
	 cvsbackup.pl	cvsgrew		findclass	grab 		\
	 graphBugs	include		inspr		isoToUSB.sh 	\
	 length		mismatch	reverse		sdiffcvs	\
	 setenv2export	tailf		traceln
	if [ ! -d "$(HOME)/bin" ] ; then mkdir "$(HOME)/bin" ; fi
	cp -i \
	  backup	cntlines	collect_stats	copysnap	\
	  cvsbackup.pl	cvsgrew		findclass	grab 		\
	  graphBugs	include		inspr		isoToUSB.sh 	\
	  length	mismatch	reverse		sdiffcvs	\
	  setenv2export	tailf		traceln				\
	  "$(HOME)/bin"
