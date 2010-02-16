git-multipush
=============
Gavin Beatty <gavinbeatty@gmail.com>

git multipush: Push a branch to multiple remotes in one command. Particularly
useful for people hosting on multiple git repo providers all at once.
e.g., github.com, gitorious.org and repo.or.cz.

From the manpage:

    NAME
           git-multipush - push a branch to multiple remotes in one command.

    SYNOPSIS
           git multipush [OPTIONS] [<remote>...] [-- GIT_OPTIONS]

    DESCRIPTION
           Particularly useful for people hosting on multiple git repo providers
           all at once. e.g., github.com, gitorious.org and repo.or.cz.

    OPTIONS
           -v, --verbose
               Print the git commands before executing them.

           -e, --error
               Fail immediately when any push fails. Otherwise, we fail after all
               pushes with the error code of the last failed push.

           -n, --dry-run
               Don’t run any of the git commands. Only print them, as in -v.

           -b, --branch
               The branch to push. If none given, none are passed on to git push.

           --version
               Print version info in the format git multipush version $version.

           <branch>
               Any branch name that git push can handle.

           <remote>...
               The list of remotes to push to — defaults to origin.

           GIT_OPTIONS
               Options passed directly on to git push.

    EXIT STATUS
           0 on success and non-zero on failure.

    AUTHOR
           Gavin Beatty <gavinbeatty@gmail.com>

    RESOURCES
           Website: http://code.google.com/p/git-multipush/

    REPORTING BUGS
           Please report all bugs and wishes to <gavinbeatty@gmail.com>

    COPYING
           git-multipush Copyright (C) 2010 Gavin Beatty, <gavinbeatty@gmail.com>

           Free use of this software is granted under the terms of the GNU General
           Public License version 3, or at your option, any later version.
           (GPLv3+)


Dependencies
------------

* sh: in POSIX
* getopts: in POSIX.
* git: it is very much not in POSIX.

As such, git-multipush should be portable across all platforms that Git supports.


License
-------

git multipush Copyright 2010 Gavin Beatty <gavinbeatty@gmail.com>.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or (at
your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You can find the GNU General Public License at:
http://www.gnu.org/licenses/


Install
-------
    make

Default prefix is /usr/local:
    sudo make install

Select your own prefix:
    make install prefix=~/.local


Website
-------
http://code.google.com/p/git-multipush/

