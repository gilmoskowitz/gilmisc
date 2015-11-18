#!/bin/bash

PROG=$(basename $0)
DESTDIR="$TMPDIR/$PROG"

[ -d "$DESTDIR" ] || mkdir -p "$DESTDIR" || exit 1
rm "$DESTDIR"/*
for REPO in $(cat repolist) ; do
  I=1
  DONE=false
  while ! $DONE ; do
    DEST="$DESTDIR/${REPO}.${I}.json"
    curl -u gilmoskowitz${PWSUFFIX} "https://api.github.com/repos/xtuple/${REPO}/pulls?state=closed&sort=created&direction=desc&page=${I}&per_page=100" > $DEST 2> /dev/null
    if [ ! -e $DEST ] ; then DONE=true
    elif [ $(wc -l $DEST | awk '{print $1}') -lt 100 ] ; then DONE=true
    fi
    I=$(($I + 1))
  done
  node prhist.js $DESTDIR/${REPO}.*.json
done
