#!/usr/bin/env bash

set -euo pipefail

## Requires
BIN_REQUIRES='
	dirname mkdir mktemp
	rm rmdir curl
	grep sed tr
	date realpath
	wget mv ln basename
'
for CHECK_BIN in $BIN_REQUIRES ; do
	type -P $CHECK_BIN >/dev/null || ( echo "$0: Could not find $CHECK_BIN" && false )
done

CURDIR=`dirname "$0"`

UDD_DUMP_URL='https://udd.debian.org/dumps/udd.dump'

WORKDIR="$CURDIR"/../work/debian-udd
LOCAL_FILE="$WORKDIR/udd.dump"

mkdir -p $WORKDIR

export MYTEMPDIR=$(mktemp -p $WORKDIR -d)
export MYTEMPDATA="$MYTEMPDIR/udd.dump"

cleanup() {
	[ -f "$MYTEMPDATA" ] && rm "$MYTEMPDATA";
	[ -d "$MYTEMPDIR"  ] && rmdir "$MYTEMPDIR";
}

trap cleanup EXIT

REMOTE_LAST_MODIFIED=$(curl -sI "$UDD_DUMP_URL" \
	| grep -i "Last-Modified" \
	| sed 's/Last-Modified: //i' \
	| tr -d '\r')
REMOTE_LAST_MODIFIED_TIMESTAMP=$(date -d "$REMOTE_LAST_MODIFIED" +%s)

REAL_LOCAL_FILE=$(realpath "$LOCAL_FILE")
if [ -f $REAL_LOCAL_FILE ]; then
  LOCAL_LAST_MODIFIED_TIMESTAMP=$(date -r "$REAL_LOCAL_FILE" +%s)
else
  LOCAL_LAST_MODIFIED=''
fi

if [ "$REMOTE_LAST_MODIFIED_TIMESTAMP" != "$LOCAL_LAST_MODIFIED_TIMESTAMP" ]; then
  echo "The file $LOCAL_FILE has been modified (old: $LOCAL_LAST_MODIFIED_TIMESTAMP, new: $REMOTE_LAST_MODIFIED_TIMESTAMP)."
  wget -N -P $MYTEMPDIR $UDD_DUMP_URL

  DATE_SUFFIX="$(date --utc -Is -r "$MYTEMPDATA" | sed 's/\+00:00$//' | tr -d ':-')"
  NEW_FILE="$WORKDIR/udd.$DATE_SUFFIX.dump"

  mv $MYTEMPDATA $NEW_FILE
  ln -sf $(basename "$NEW_FILE") $LOCAL_FILE
else
  echo "The file $LOCAL_FILE has not been modified."
fi
