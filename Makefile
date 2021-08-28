# io - dynamic window manager
# See LICENSE file for copyright and license details.

include config.mk

SRC = drw.c io.c util.c
OBJ = ${SRC:.c=.o}

all: options io

options:
	@echo io build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

.c.o:
	${CC} -c ${CFLAGS} $<

${OBJ}: config.h config.mk

config.h:
	cp config.def.h $@

io: ${OBJ}
	${CC} -o $@ ${OBJ} ${LDFLAGS}

clean:
	rm -f io ${OBJ} io-${VERSION}.tar.gz

dist: clean
	mkdir -p io-${VERSION}
	cp -R LICENSE Makefile README config.def.h config.mk\
		io.1 drw.h util.h ${SRC} io.png transient.c io-${VERSION}
	tar -cf io-${VERSION}.tar io-${VERSION}
	gzip io-${VERSION}.tar
	rm -rf io-${VERSION}

install: all
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f io ${DESTDIR}${PREFIX}/bin
	chmod 755 ${DESTDIR}${PREFIX}/bin/io
	mkdir -p ${DESTDIR}${MANPREFIX}/man1
	sed "s/VERSION/${VERSION}/g" < io.1 > ${DESTDIR}${MANPREFIX}/man1/io.1
	chmod 644 ${DESTDIR}${MANPREFIX}/man1/io.1

uninstall:
	rm -f ${DESTDIR}${PREFIX}/bin/io\
		${DESTDIR}${MANPREFIX}/man1/io.1

.PHONY: all options clean dist install uninstall
