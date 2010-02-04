prefix=/usr/local

all: doc

doc/git-multipush.1: doc/git-multipush.1.txt
	a2x -f manpage -L doc/git-multipush.1.txt

doc/git-multipush.1.html: doc/git-multipush.1.txt
	asciidoc doc/git-multipush.1.txt

doc: doc/git-multipush.1 doc/git-multipush.1.html

clean:
	rm -f doc/git-multipush.1 doc/git-multipush.1.html

install: git-multipush doc/git-multipush.1 doc/git-multipush.1.html
	install -d -m 0755 $(prefix)/bin
	install -m 0755 git-multipush $(prefix)/bin
	install -d -m 0755 $(prefix)/share/man/man1
	install -m 0644 doc/git-multipush.1 $(prefix)/share/man/man1/
	install -m 0644 doc/git-multipush.1.html $(prefix)/share/man/man1/

