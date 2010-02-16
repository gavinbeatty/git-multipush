prefix=/usr/local
DESTDIR=

all: doc

doc/git-multipush.1: doc/git-multipush.1.txt
	a2x -f manpage -L doc/git-multipush.1.txt

doc/git-multipush.1.html: doc/git-multipush.1.txt
	asciidoc doc/git-multipush.1.txt

doc/git-multipush.txt: doc/git-multipush.1
	groff -t -e -P -c -mandoc -Tutf8 doc/git-multipush.1 | col -bx \
	> doc/git-multipush.txt

doc: doc/git-multipush.1 doc/git-multipush.1.html doc/git-multipush.txt

clean-doc:
	rm -f doc/git-multipush.1 doc/git-multipush.1.html doc/git-multipush.txt

clean: clean-doc

install-doc: doc/git-multipush.1 doc/git-multipush.1.html doc/git-multipush.txt
	install -d -m 0755 $(DESTDIR)$(prefix)/share/man/man1
	install -m 0644 doc/git-multipush.1 $(DESTDIR)$(prefix)/share/man/man1/
	install -m 0644 doc/git-multipush.1.html $(DESTDIR)$(prefix)/share/man/man1/
	install -d -m 0755 $(DESTDIR)$(prefix)/share/doc/git-multipush/
	install -m 0644 doc/git-multipush.txt $(DESTDIR)$(prefix)/share/doc/git-multipush/

install-bin:
	install -d -m 0755 $(DESTDIR)$(prefix)/bin
	install -m 0755 git-multipush $(DESTDIR)$(prefix)/bin

install: install-bin install-doc

