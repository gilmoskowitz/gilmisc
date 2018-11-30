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

for DIR in $DIRLIST ; do
  cd $STARTDIR
  printf "%-*s\n" ${COLUMNS:-80} $DIR | sed -e "s/ /#/g" -e "s/#/ /"
  if [ -d $DIR/.git ] ; then
    cd $DIR
  elif [ -n "$REPOLIST" ] ; then
    git clone $(awk -v FS='	' '$1 == "'$DIR'" { print $3 }' $REPOLIST)
    cd $DIR
  fi
#  for FORK in $(curl -u ${GITHUBUSER}${PWSUFFIX} "https:://api.github.com/repos/xtuple/$DIR/forks" \
#                | cut -f4 -d '"') ; do
#    REMOTENAME=$(${FORK/\/*} | tr "[a-z]" "[A-Z]")
#    if ! git remote show $REMOTENAME > /dev/null 2>&1 ; then
#      git remote add $REMOTENAME "https://github.com/$FORK"
#    fi
#  done
  git fetch --all && git pull
done
