# usage: perl cvsbackup.pl
#
# Write a backup copy to the directory named by $backuproot
# of the files modified in CVS checkouts.  The list of directories
# containing checkouts is in @checkouts.  It writes one zip file for
# each checkout area, containing all of the modified files.
# It tries to filter out built files, but isn't very good at it yet.

$backuproot = "/qa/users/gilm/backup";

@checkouts = ( "$ENV{HOME}/workroot/*" );

# end customization

foreach $curcheckout (map { glob($_) } @checkouts) {
    chdir $curcheckout;
    @ziplist = ();

    open(FIND, "find * -type d -print | sort |");
    while ($dirname = <FIND>) {
	chomp $dirname;
    	if ($dirname =~ /\WCVS$/ || ! -d "$dirname/CVS") {
	    print STDERR "skipping $dirname =============\n" if $debug;
	    next;
	}

	print STDERR "reading $dirname =============\n" if $debug;
	
	if (! opendir(CURDIR, $dirname)) {
	    print "$dirname: $!\n";
	    next;
	}

	if ($ENV{VISUAL} =~ /emacs|gvim/ || $ENV{EDITOR} =~ /emacs|gvim/) {
	    @allfiles = grep -f,  map "$dirname/$_", readdir(CURDIR);
	    # DOIT: we only want to filter out .class if there's a
	    # corresponding .java
	    @files = grep !/(~|\.class)$/, @allfiles;
	} else {
	    @files = grep -f,  map "$dirname/$_", readdir(CURDIR);
	}

	closedir(CURDIR);

	# now filter out specific files generated by builds
	@files = grep !/(idltojava|idlc|newbaseline.report|\.[aso]|\.lis)$/, @files;

	open(STATUS, "cvs -q status -l @files |");

	while (<STATUS>) {
	    if (/File:\s(.*)\sStatus: (.*)/) {
		$file = "$dirname/$1";
		if (! /Up-to-date|Needs (Patch|Checkout)/) {
		    print "$file\n" if $debug;
		    @ziplist = (@ziplist, "$file");
		}
	    }
	}

	close(STATUS);
    }

    if ( scalar @ziplist ) {
	$zipfilename = "$backuproot/`basename $curcheckout`_`date +%Y%m%d`"; 
	system("zip -v $zipfilename @ziplist");
    }
}