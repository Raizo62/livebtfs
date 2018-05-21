#!/usr/bin/make -f
#
NAME	=	livebtfs
VERSION	=	3.1

BINDIR	=	$(DESTDIR)/usr/local/bin
MANDIR	=	$(DESTDIR)/usr/local/man/man1

EXEC	=	$(NAME) $(NAME)stat

SRC		=	src
MAN		=	man

CC		=	g++

MODE= -O4 -Wall -fomit-frame-pointer # //////////      RELEASE
#MODE= -g -Wall -D_DEBUG # //////////      DEBUG
#MODE= -pg # //////////      PROFILER --> view with : gprof $(NAME)

DEFS = -DPACKAGE=\"$(NAME)\" -DVERSION=\"$(VERSION)\"

FUSE_CFLAGS = -D_FILE_OFFSET_BITS=64 -I/usr/include/fuse
LIBTORRENT_CFLAGS = -DTORRENT_DISABLE_LOGGING -DTORRENT_USE_OPENSSL -DBOOST_ASIO_HASH_MAP_BUCKETS=1021 -DBOOST_EXCEPTION_DISABLE -DBOOST_ASIO_ENABLE_CANCELIO -DTORRENT_LINKING_SHARED -I/usr/include/libtorrent

CFLAGS  +=  $(MODE) $(FUSE_CFLAGS) $(LIBTORRENT_CFLAGS)

FUSE_LIBS = -lfuse -lpthread
LIBTORRENT_LIBS = -ltorrent-rasterbar -lboost_system
LIBCURL_LIBS = -lcurl

LIBS = $(FUSE_LIBS) $(LIBTORRENT_LIBS) $(LIBCURL_LIBS)

EUID	:= $(shell id -u -r)

##############################

% : $(SRC)/%.cc $(SRC)/%.h Makefile
	$(CC) $(CFLAGS) $(DEFS) $(LDFLAGS) $(LIBS) -o $@ $<

.PHONY: all clean build install

build : $(EXEC)

all : clean build install

clean:
	-rm -f *~ $(SRC)/*~ $(MAN)/*~
	-rm -f $(EXEC)

install : $(EXEC)
ifneq ($(EUID),0)
	@echo "Please run 'make install' as root user"
	@exit 1
endif
	chmod +x $(EXEC)
	# Install binaire :
	mkdir -p $(BINDIR) && cp -p $(EXEC) $(BINDIR)
	# Install mapage :
	mkdir -p $(MANDIR) && gzip -c $(MAN)/$(NAME).1 > $(MANDIR)/$(NAME).1.gz
