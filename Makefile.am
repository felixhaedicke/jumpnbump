SUBDIRS = sdl modify data

bin_PROGRAMS = jumpnbump

bin_SCRIPTS = @BIN_SCRIPTS@

EXTRA_SCRIPTS = #stupid automake...

man_MANS = jumpnbump.6

noinst_DATA = jumpnbump.html
CLEANFILES = jumpnbump.html
jumpnbump.html: jumpnbump.6
	-rman "$<" -f HTML >"$@"

jumpnbump_SOURCES = \
	filter.c \
	fireworks.c \
	main.c \
	menu.c

AM_CFLAGS = -DPREFIX="\"@prefix@\""

noinst_HEADERS = \
	globals.h \
	dj.h \
	filter.h

EXTRA_DIST = \
	jnbmenu.tcl.in \
	jumpnbump.6 \
	XF86Config-4 \
	gob.txt indent.txt readme.txt source.txt readme-win32.txt \
	LINKS \
	jumpnbump.ico \
	jumpnbump-kdialog.in jumpnbump-xdialog.in \
	jumpnbump.fbcon jumpnbump.svgalib \
	autogen.sh

jumpnbump_LDADD = \
	sdl/libsdl.a

#bindir = @prefix@/games

dist-hook:
	-for DIR in PB VisualC6 dos levelmaking ; \
	do \
		cp -Rfp @srcdir@/$$DIR $(distdir)/$$DIR ; \
		find $(distdir) -name CVS -exec rm -rvf '{}' ';' ; \
	done


new: clean all
