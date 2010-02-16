#!/bin/sh

set -e
set -u

progname="$1"
vvar="$2"
vfile="$3"
shift 3

lf='
'

if test -f version ; then
    ver=$(cat version)
else
    ver="$(git describe "$@" --abbrev=4 | sed -e "s/^${progname}-v//")"
    case "$ver" in
    "$lf")
        exit 1
        ;;
    [0-9]*)
        git update-index -q --refresh
        if test -n "$(git diff-index --name-only HEAD --)" ; then
            ver="${ver}-dirty"
        fi
        ;;
    esac
fi

echo "${vvar} = $ver" >&2
echo "${vvar}=${ver}" > "$vfile"

