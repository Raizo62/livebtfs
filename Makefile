#!/usr/bin/make -f
#
NAME	=	livebtfs
VERSION	=	7.4
BINDIR	=	$(DESTDIR)/usr/local/bin
MANDIR	=	$(DESTDIR)/usr/local/man/man1

EXEC	=	$(NAME) $(NAME)stat

SRC		=	src
MAN		=	man

CC		=	g++

MODE= -O3 -s -Wextra -pedantic -Wall # //////////      RELEASE
#MODE= -g -Wall -D_DEBUG # //////////      DEBUG
#MODE= -pg # //////////      PROFILER --> view with : gprof $(NAME)

EDITOR	=	geany

DEFS = -DPACKAGE=\"$(NAME)\" -DVERSION=\"$(VERSION)\"

FUSE_CFLAGS = -D_FILE_OFFSET_BITS=64 -I/usr/include/fuse
LIBTORRENT_CFLAGS = -DTORRENT_DISABLE_LOGGING -DTORRENT_USE_OPENSSL -DTORRENT_LINKING_SHARED -I/usr/include/libtorrent

CFLAGS  +=  $(FUSE_CFLAGS) $(LIBTORRENT_CFLAGS)

FUSE_LIBS = -lfuse -lpthread
LIBTORRENT_LIBS = -ltorrent-rasterbar
LIBCURL_LIBS = -lcurl
CRYPTO_LIBS = -lcrypto

LIBS = $(FUSE_LIBS) $(LIBTORRENT_LIBS) $(LIBCURL_LIBS) $(CRYPTO_LIBS)

EUID	:= $(shell id -u -r)

##############################

.PHONY: all clean build install man edit cppcheck zip

% : $(SRC)/%.cc $(SRC)/%.h Makefile
	$(CC) $(MODE) $(CFLAGS) $(DEFS) -o $@ $< $(LDFLAGS) $(LIBS)

build : $(EXEC) man

$(MAN)/$(NAME).1.gz : $(MAN)/$(NAME).1
	gzip -c $(MAN)/$(NAME).1 > $(MAN)/$(NAME).1.gz

man : $(MAN)/$(NAME).1.gz

all : clean build install

clean:
	-rm -f *~ $(SRC)/*~ $(MAN)/*~
	-rm -f $(EXEC) $(MAN)/$(NAME).1.gz $(NAME)-cppcheck.xml

edit:
	$(EDITOR) $(SRC)/* [Mm]akefile README.md &

cppcheck:
	cppcheck --verbose --enable=all --enable=style --xml $(CFLAGS) $(DEFS) -D_DEBUG $(SRC)/*.cc 2> $(NAME)-cppcheck.xml

zip:
	tar czfvp $(NAME)_v$(VERSION).tgz [Mm]akefile $(SRC)/ $(MAN)/ scripts/ README.md LICENSE --transform="s+^+$(NAME)_v$(VERSION)/+"

install : $(EXEC) man
ifneq ($(EUID),0)
	@echo "Please run 'make install' as root user"
	@exit 1
endif
	chmod +x $(EXEC)
	# Install binaire :
	mkdir -p $(BINDIR) && cp -p $(EXEC) $(BINDIR)
	# Install mapage :
	mkdir -p $(MANDIR) && cp $(MAN)/$(NAME).1.gz $(MANDIR)/$(NAME).1.gz
