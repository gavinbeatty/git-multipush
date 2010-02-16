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
git multipush [options] -s <remote> [...]
git multipush [options] --unset
git multipush [options] -g
--
v,verbose   print each command as it is run
e,error     exit with error on the first git push error
n,dry-run   don't run any commands, just print them
b,branch=   directly passed on to git push as follows: git push <remote> <branch>
s,set       the given remotes are put in a comma-separated list in the config in multipush.remotes
unset       unset multipush.remotes
g,get       get multipush.remotes
system      passed on to git config
global      passed on to git config
file=       passed on to git config
d,debug     print debug info
version     print version info in 'git multipush version \$version' format"

. "$(git --exec-path)/git-sh-setup"

debug_run() {
    if test -n "$debug" ; then
        printf "debug:" >&2
        "$@" >&2
    fi
}
verbose_print() {
    if test -n "$verbose" ; then
        echo "$@" >&2
    fi
}
run() {
    if test -z "$dryrun" ; then
        "$@"
    fi
}

doit() {
    debug_run sq "$@"
    verbose_print "$@"
    run "$@"
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
            exxit="$e"
        fi
    fi
    return 0
}

comma_assert() {
    for i in "$@" ; do
        if echo "$i" | grep -F -q ',' ; then
            die "Cannot add a default remote with a comma in its name"
        fi
    done
}

git_config() {
    if test -n "${file=}" ; then
        file=" $(sq --file "$file")"
    fi
    if test -n "${system=}" ; then
        system=" $(sq "$system")"
    fi
    if test -n "${global=}" ; then
        global=" $(sq "$global")"
    fi
    eval "doit git config${system}${global}${file} $(sq "$@")"
}

main() {
    dryrun=""
    verbose=""
    fail=""
    debug=""
    branch=""
    set_opt=""
    unset_opt=""
    get_opt=""
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
        -s|--set)
            set_opt="true"
            ;;
        --unset)
            unset_opt="true"
            ;;
        -g|--get)
            get_opt="true"
            ;;
        --system)
            system="--system"
            ;;
        --global)
            global="--global"
            ;;
        --file)
            file="$2"
            shift
            ;;
        -d|--debug)
            debug="true"
            verbose=""
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

    if test -n "$set_opt" ; then
        if test $# -eq 0 ; then
            die "Must give at least one <remote> with -s|--set"
        fi
        remote_commas="$1"
        shift
        comma_assert "$remote_commas"
        for rem in "$@" ; do
            comma_assert "$rem"
            remote_commas="${remote_commas},${rem}"
        done
        git_config multipush.remotes "$remote_commas"
        exit 0
    elif test -n "$unset_opt" ; then
        if test $# -ne 0 ; then
            die "Unexpected arguments given with --unset"
        fi
        git_config --unset multipush.remotes
        exit 0
    elif test -n "$get_opt" ; then
        git_config multipush.remotes
        exit 0
    fi

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

    exxit=0
    if test $# -gt 0 ; then
        for rem in "$@" ; do
            if test -z "${branch-}" ; then
                evalit "doit git push${git_opts-} $(sq "$rem")"
            else
                evalit "doit git push${git_opts-} $(sq "$rem") $(sq "$branch")"
            fi
        done
    else
        e=0
        remote_commas="$(git_config multipush.remotes || e=$?)"
        debug_run echo " multipush.remotes =$(sq "$remote_commas")"
        if test "$e" -eq 0 && test -n "${remote_commas-}" ; then
            remotes="$(echo "$remote_commas" | sed -e 's/,/ /g')"
            for rem in $remotes ; do
                evalit "doit git push${git_opts-} $(sq "$rem")"
            done
        else
            if test -z "${branch-}" ; then
                evalit "doit git push${git_opts-}"
            else
                evalit "doit git push${git_opts-} origin$(sq "$branch")"
            fi
        fi
    fi
    exit "$exxit"
}

trap "echo \"caught SIGINT\" ; exit 1 ;" INT
trap "echo \"caught SIGTERM\" ; exit 1 ;" TERM
trap "echo \"caught SIGHUP\" ; exit 1 ;" HUP

main "$@"

