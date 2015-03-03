#!/bin/bash

PROG=$(basename $0)
DESTDIR="$TMPDIR/$PROG"

DONE=false

[ -d "$DESTDIR" ] || mkdir -p "$DESTDIR" || exit 1

I=1
while ! $DONE ; do
  DEST="$DESTDIR/github.${I}.json"
  curl -u gilmoskowitz "https://api.github.com/orgs/xtuple/repos?page=${I}&per_page=100" > $DEST
  if [ ! -e $DEST ] ; then DONE=true
  elif [ $(wc -l $DEST | awk '{print $1}') -lt 100 ] ; then DONE=true
  fi
  I=$(($I + 1))
done

cat "$DESTDIR"/github.*.json && rm "$DESTDIR"/github.*.json 
