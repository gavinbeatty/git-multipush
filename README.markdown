git-multipush
=============
Gavin Beatty <gavinbeatty@gmail.com>

git multipush: Push a branch to multiple remotes in one command. Particularly
useful for people hosting on multiple git repo providers all at once.
e.g., github.com, gitorious.org and repo.or.cz.

    Usage: git multipush [-v] [-n] [-b <branch>] [<remote>...] [-- GIT_OPTIONS]
    Usage: git multipush [-v] [-e] [-n] [-b <branch>] [<remote>...] [-- GIT_OPTIONS]
    
    <branch> is the branch to push -- if none given, pass none to git push
    <remote>... is the list of remotes to push to -- defaults to origin
    
    -v -- print each command as it is run.
    -e -- fail immediately when any push fails. Otherwise, we fail after all
          pushes with the error code of the last failed push.
    -n -- don't run any commands, just print them.
    -b <branch> -- push <branch> instead of `git symbolic-ref HEAD`
    -d -- debug
    
    GIT_OPTIONS -- passed directly on to git push.


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
Default prefix is /usr/local:
    sudo make install

Select your own prefix:
    make install prefix=~/.local


Website
-------
http://code.google.com/p/git-multipush/

