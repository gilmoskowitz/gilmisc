#!/bin/bash

set -e

PROG=$(basename $0)
STARTDIR=$(pwd)
WORKDIR=${TMPDIR:=/tmp}/$PROG.$$

PROGDIR=$(dirname $0)
if ! [[ $PROGDIR =~ ^/ ]] ; then
  PROGDIR=$(pwd)/$PROGDIR
fi
PATH="$PROGDIR:$PATH"

GHUSER=$(whoami)
GHPASS=

usage() {
  cat <<EOF
$PROG -h        get this usage info
$PROG [ -u username ] { -w password-or-token | -W token-file }

-u username     GitHub username (default: $(whoami))
-w password-or-token    GitHub access token if 2FA is enabled, otherwise GitHub password
-W token-file           Path to file containing the GitHub access token or password
EOF
}

while getopts hu:w:W: OPT ; do
  case $OPT in
    h) usage        ; exit 0 ;;
    u) GHUSER=$OPTARG        ;;
    w) GHPASS=$OPTARG        ;;
    W) GHPASS=$(cat $OPTARG) ;;
  esac
done

if [ -z "$GHPASS" ] ; then
  echo "$PROG: GitHub token or password is required; pass either -w or -W"
  exit 1
fi

rm -rf $WORKDIR && mkdir -p $WORKDIR
cat > $WORKDIR/forksToRemotes.js <<EOF
const fs    = require('fs'),
      files = process.argv.slice(2);

files.forEach(function (file) {
  var text = fs.readFileSync(file),
      obj  = JSON.parse(text);

  if (! Array.isArray(obj)) {
    console.error(\`\${file} is not an array\`);
  } else {
    obj.forEach(f =>
      console.log(
        \`if ! git remote show \${f.owner.login} > /dev/null 2>&1 ; then
          git remote add \${f.owner.login} \${f.html_url}
        fi\`)
    );
  }
});
EOF

REPOLIST=$(ls -d */.git | sed -e "s,/.git,," | sort -r)
REPOCNT=$(wc -w <<<$REPOLIST)
COUNT=0

cd $STARTDIR
for REPO in $REPOLIST ; do
  echo -n $((COUNT++))
  printf " of %-03s %s %s\n" $REPOCNT $REPO \
         '######################################################################' |
         cut -c -80
  pushd $REPO > /dev/null 2>&1
  PAGE=1
  curl -u $GHUSER:$GHPASS -o $WORKDIR/forks_list.$REPO.$PAGE \
       "https://api.github.com/repos/xtuple/$REPO/forks?page=$PAGE&per_page=100"
  node $WORKDIR/forksToRemotes.js $WORKDIR/forks_list.$REPO.$PAGE | bash
  git fetch --all
  popd > /dev/null 2>&1
done
