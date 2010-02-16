#!/bin/sh

## git multipush Copyright 2010 Gavin Beatty <gavinbeatty@gmail.com>.
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or (at
## your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You can find the GNU General Public License at:
##   http://www.gnu.org/licenses/

set -e

# @VERSION@

version_print() {
    echo "git multipush version ${VERSION}"
}

SUBDIRECTORY_OK=Yes
OPTIONS_KEEPDASHDASH="yes"
OPTIONS_SPEC="\
git multipush [options] [<remote>..] [-- GIT_OPTIONS]
--
v,verbose   print each command as it is run
e,error     exit with error on the first git push error
n,dry-run   don't run any commands, just print them
b,branch=   directly passed on to git push as follows: git push <remote> <branch>
d,debug     print debug info
version     print version info in 'git multipush version \$version' format"

. "$(git --exec-path)/git-sh-setup"

doit() {
    if test -n "$debug" ; then
        sq "$@"
    elif test -n "$verbose" ; then
        echo "$@"
    fi
    if test -z "$dryrun" ; then
        "$@"
    fi
}

sq() {
    git rev-parse --sq-quote "$@"
}

evalit() {
    e=0
    eval "$1" || e=$?
    if test "$e" -ne 0 ; then
        if test -n "$fail" ; then
            exit "$e"
        else
            exit="$e"
        fi
    fi
    return 0
}

main() {
    dryrun=""
    verbose=""
    fail=""
    debug=""
    branch=""
    while test $# -ne 0 ; do
        case "$1" in
        -v|--verbose)
            verbose="true"
            ;;
        -e|--error)
            fail="true"
            ;;
        -n|--dry-run)
            dryrun="true"
            verbose="true"
            ;;
        -b|--branch)
            branch="$2"
            shift
            ;;
        -d|--debug)
            debug="true"
            ;;
        --version)
            version_print
            exit 0
            ;;
        --)
            shift
            break
            ;;
        esac
        shift
    done

    while test $# -gt 0 ; do
        if test x"$1" = x"--" ; then
            shift
            break
        fi
        remotes="${remotes- }$(sq "$1")"
        shift
    done
    while test $# -gt 0 ; do
        git_opts="${git_opts- }$(sq "$1")"
        shift
    done

    eval set -- "${remotes-}"

    exit=0
    if test $# -gt 0 ; then
        for rem in "$@" ; do
            if test -z "${branch-}" ; then
                evalit "doit git push${git_opts-} $(sq "$rem")"
            else
                evalit "doit git push${git_opts-} $(sq "$rem") $(sq "$branch")"
            fi
        done
    else
        evalit "doit git push${git_opts-}"
    fi
    exit "$exit"
}

trap "echo \"caught SIGINT\" ; exit 1 ;" INT
trap "echo \"caught SIGTERM\" ; exit 1 ;" TERM
trap "echo \"caught SIGHUP\" ; exit 1 ;" HUP

main "$@"

