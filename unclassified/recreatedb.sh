#!/bin/sh
PROG=`basename $0`

DESTDB=
DESTHOST=localhost
DESTPORT=
DESTTEMPLATE=template1
DESTUSER=admin
JOBCNT=1

SRCFILE=

usage() {
  echo "$PROG -d dbname -f backupfile -h host -p port -t templatedb -U username [ -W password ]"
  echo
  echo "-d dbname 	($DESTDB)"
  echo "-f backupfile 	($SRCFILE)"
  echo "-h host 	($DESTHOST)"
  echo "-p port 	($DESTPORT)"
  echo "-t templatedb 	($DESTTEMPLATE)"
  echo "-U username	($DESTUSER)"
  echo "-W password     (default is user has to type it multiple times)"
  echo "-j jobcnt       ($JOBCNT, only applies to .backup files)"
}

ARGS=`getopt d:f:h:j:p:t:U: $*`
if [ $? != 0 ] ; then
  usage
  exit 1
fi
set -- $ARGS

while [ "$1" != -- ] ; do
  case "$1" in
    -d) DESTDB=$2
        shift
        ;;
    -f) SRCFILE=$2
        shift
        ;;
    -h) DESTHOST=$2
        shift
        ;;
    -j) JOBCNT=$2
        shift
        ;;
    -p) DESTPORT=$2
        shift
        ;;
    -t) DESTTEMPLATE=$2
        shift
        ;;
    -U) DESTUSER=$2
        shift
        ;;
    *) usage
       exit 1
       ;;
  esac
  shift
done
shift #past the --

if [ -z "$DESTDB" -o -z "$DESTHOST" -o -z "$DESTPORT" -o -z "$DESTTEMPLATE" -o -z "$DESTUSER" -o -z "$SRCFILE" ] ; then
  usage
  exit 1
fi

psql -e -q -h $DESTHOST -d $DESTTEMPLATE -p $DESTPORT -U $DESTUSER <<EOF
  drop database $DESTDB;
  create database $DESTDB;
  grant all on database $DESTDB to admin;
EOF

if expr "$SRCFILE" : ".*.backup" > /dev/null ; then
  pg_restore -h $DESTHOST -d $DESTDB -p $DESTPORT -U $DESTUSER -j $JOBCNT $SRCFILE
elif expr "$SRCFILE" : ".*.sql" > /dev/null ; then
  psql -e -q -h $DESTHOST -d $DESTDB -p $DESTPORT -U $DESTUSER -f $SRCFILE
else
  echo Do not know how to process $SRCFILE
  exit 1
fi

while [ -n "$1" ] ; do
  read -p "Process $1? " RESULT
  if [ "$RESULT" = y -o "$RESULT" = Y ] ; then
    psql -e -q -h $DESTHOST -d $DESTDB -p $DESTPORT -U $DESTUSER -f $1
  fi
  shift
done
