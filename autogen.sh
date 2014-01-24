#!/bin/sh

aclocal && \
autoconf && \
autoheader && \
automake --foreign --add-missing || {
echo '*** Failed ***'
exit 1
}

echo you are now ready to run ./configure
