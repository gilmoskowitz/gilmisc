#!/bin/bash

PROG=$(basename $0)
WORKDIR=${TMPDIR:=/tmp}/$PROG.$$
STARTDIR=$(pwd)
REPOLIST=
READDIR=false

PROGDIR=$(dirname $0)
if ! [[ $PROGDIR =~ ^/ ]] ; then
  PROGDIR=$(pwd)/$PROGDIR
fi
PATH="$PROGDIR:$PATH"

usage () {
cat << EOUSAGE
  $PROG -h
  $PROG [ -f tsvFile | -i ]
EOUSAGE
}

while getopts f:hi OPT ; do
  case $OPT in
    f) REPOLIST=$OPTARG ;;
    h) usage && exit 0  ;;
    i) READDIR=true     ;;
  esac
done

mkdir -p $WORKDIR

if $READDIR ; then
  REPOLIST=
  DIRLIST=$(ls)
elif [ -z "$REPOLIST" ] ; then
  REPOLIST=$WORKDIR/repoList.tsv
  listRepos.sh > $REPOLIST
  DIRLIST=$(cut -f1 -d"	" $REPOLIST)
else
  DIRLIST=$(cut -f1 -d"	" $REPOLIST)
fi
DIRLIST="$(echo $DIRLIST | tr ' ' '\n' | sort)"
DIRCNT=$(wc -w <<<$DIRLIST)
COUNT=0

cd $STARTDIR
for DIR in $DIRLIST ; do
  echo -n $((++COUNT))
  printf " of %-03s %s %s\n" $DIRCNT $DIR \
         '######################################################################' |
         cut -c -80
  if [ -d $DIR/.git ] ; then
    pushd $DIR
  elif [ -n "$REPOLIST" ] ; then
    git clone $(awk -v FS='	' '$1 == "'$DIR'" { print $3 }' $REPOLIST)
    pushd $DIR
  fi
  git fetch --all && git pull
  popd
done
