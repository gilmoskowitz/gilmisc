#!/bin/bash

PROG=`basename $0`

# empty => execute, echo => show what would be done but don't do it
DO=

usage() {
cat <<EOF
usage: $PROG [ -h ]
       $PROG [ -o intermed_file.img ] [ -n ] -d /dev/target <file>.iso
  -h  show this help
  -d  path to the flash drive
  -o  name the intermediate destination file [ <file>.img ]
  -n  don't modify any files but report what would be done
EOF

if [ $# -gt 0 ] ; then
  cat <<EOF
$PROG creates a bootable USB flash drive from a bootable ISO disk image.

It's your responsibility to back up the contents of the flash drive.

To get a list of possible target devices, try
    diskutil list
$PROG converts a disk image in .iso format to an intermediate file,
then writes that to the flash drive. If the name specified with the
-o option does not end with .img, a .img will be appended.

TODO: This script is based on
  http://www.ubuntu.com/download/desktop/create-a-usb-stick-on-mac-osx
Why do these instructions use the .img suffix in spite of
acknowledging that hdutil tries to use the .dmg suffix?
EOF
fi
}

while getopts ho:d:n OPT ; do
  case $OPT in
    h)  usage long
        exit 0
        ;;
    o)  OUTFILE=$OPTARG
        ;;
    d)  TARGET=$OPTARG
        ;;
    n)  DO=echo
        ;;
  esac
done

if [ $OPTIND -gt $# ] ; then
  echo Please name a file to copy.
  usage
  exit 1
fi

ISOFILE="${!OPTIND}"
if ! file "$ISOFILE" | egrep -q "ISO.*\(bootable\)" ; then
  echo "$ISOFILE doesn't seem to be a bootable disk image"
  exit 1
fi

if [ -z "$OUTFILE" ] ; then
  OUTFILE=`basename $ISOFILE .iso`.img         || exit 10
fi

if [ -z "$TARGET" ] ; then
  echo Please name a destination device
  usage
  exit 1
elif [ -b "$TARGET" ] ; then
  RAWTGT=`dirname $TARGET`/r`basename $TARGET`                  || exit 10
elif [ -c "$TARGET" ] ; then
  RAWTGT="$TARGET"
  TARGET=`dirname $RAWTGT`/`basename $RAWTGT | cut -c 2-`       || exit 10
elif [ -e "$TARGET" ] ; then
  echo "$TARGET exists but does not appear to be a device"
  exit 2
elif [ "$DO" = echo ] ; then
  if expr "$TARGET" : "/dev/r" > /dev/null ; then
    RAWTGT="$TARGET"
    TARGET=`dirname $RAWTGT`/`basename $RAWTGT | cut -c 2-`     || exit 10
  else
    RAWTGT=`dirname $TARGET`/r`basename $TARGET`                || exit 10
  fi
else
  echo "Cannot find the device $TARGET. Have you inserted it yet?"
  exit 2
fi

if [ "$TARGET" = /dev/disk0 ] ; then
  echo "I'm not going to overwrite what's probably your root disk"
  exit 2
fi

# UDRW is a read/write UDIF (Universal Disk Image Format) file
$DO hdiutil convert -format UDRW -o "$OUTFILE" "$ISOFILE"       || exit 3

if [ ! -e "$OUTFILE" -a -e "$OUTFILE".dmg ] ; then
  $DO mv "$OUTFILE".dmg "$OUTFILE"                              || exit 3
fi

if [ -z "$DO" ] ; then
  read -n 1 -p "Type q to quit, any other key to proceed."
  if [ "$REPLY" = q -o "$REPLY" = Q ] ; then
    exit 0
  fi
fi
$DO diskutil unmountDisk $TARGET                                || exit 3
echo "Writing $OUTFILE to $RAWTGT will take some time"
$DO sudo dd if="$OUTFILE" of="$RAWTGT" bs=1m                    || exit 3
echo "If you see a dialog now asking what to do with an unreadable disk, click IGNORE."
$DO diskutil eject $TARGET                                      || exit 3
echo "It's now safe to remove the flash drive."
