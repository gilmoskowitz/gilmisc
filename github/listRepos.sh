#!/bin/bash

PROG=$(basename $0)
DESTDIR="${TMPDIR:=/tmp}/$PROG.$$"
GITHUBUSER=gilmoskowitz
JSPROG="
  var fs = require('fs');

  process.argv.forEach(function(val, index, ary) {
    if (index < 2)
      return;
    var buffer = fs.readFileSync(val, 'utf8')
      , data   = JSON.parse(buffer)
      ;
    
    data.forEach(function (val, index, ary) {
      var fields = [ val.name, val.private, val.html_url, val.description ];
      console.log(fields.join('\t'));
    });
  });
"

NODE=node
command -v $NODE > /dev/null    || NODE=nodejs
command -v $NODE > /dev/null    || exit 1

rm   -rf "$DESTDIR"
mkdir -p "$DESTDIR"             || exit 1

echo $JSPROG > $DESTDIR/$PROG.js

WORKTODO=1
for (( I=1 ; $WORKTODO ; I++ )) ; do
  DEST="$DESTDIR/repos.${I}.json"
  curl -u ${GITHUBUSER}${PWSUFFIX} "https://api.github.com/orgs/xtuple/repos?page=${I}&per_page=100" > $DEST
  if [ ! -e $DEST ] ; then WORKTODO=0
  elif [ $(wc -l $DEST | awk '{print $1}') -lt 100 ] ; then WORKTODO=0
  fi
done

node $DESTDIR/$PROG.js "$DESTDIR"/repos.*.json
