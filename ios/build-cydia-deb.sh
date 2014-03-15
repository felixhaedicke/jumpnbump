#!/bin/bash

CURRENT_SCRIPT="`readlink -f $0`"
SRC_DIR="`dirname ${CURRENT_SCRIPT}`"/../

convert ${SRC_DIR}/data/menu.pcx -gravity center -crop 256x256+0+0 iOS-icon-rect.png || exit $?
convert -size 256x256  xc:none -fill white -draw "roundRectangle 0,0, 256, 256 25,25" iOS-icon-rect.png -compose SrcIn -composite iOS-icon-256.png || exit $?

mkdir -p cydia-package/Applications/Jumpnbump.app || exit $?
cp jumpnbump cydia-package/Applications/Jumpnbump.app || exit $?
mkdir -p cydia-package/DEBIAN || exit $?
sed "s/VERSION_PLACEHOLDER/`cat ${SRC_DIR}/VERSION`/g" ${SRC_DIR}/ios/cydia-deb-control > cydia-package/DEBIAN/control || exit $?

plutil -i ${SRC_DIR}/ios/ios-info.plist.xml -o cydia-package/Applications/Jumpnbump.app/Info.plist || exit $?
convert ${SRC_DIR}/data/menu.pcx -resize 480x320 -rotate 270 cydia-package/Applications/Jumpnbump.app/Default.png || exit $?
convert ${SRC_DIR}/data/menu.pcx -resize 960x640 -rotate 270 cydia-package/Applications/Jumpnbump.app/Default@2x.png || exit $?
convert ${SRC_DIR}/data/menu.pcx -resize 1136x640 -rotate 270 cydia-package/Applications/Jumpnbump.app/Default-568h@2x.png || exit $?
convert ${SRC_DIR}/data/menu.pcx -resize 1004x768 -rotate 270 cydia-package/Applications/Jumpnbump.app/Default-Portrait.png || exit $?
convert ${SRC_DIR}/data/menu.pcx -resize 2008x1536 -rotate 270 cydia-package/Applications/Jumpnbump.app/Default-Portrait.png || exit $?
convert ${SRC_DIR}/data/menu.pcx -resize 1024x768 cydia-package/Applications/Jumpnbump.app/Default-Landscape.png || exit $?
convert ${SRC_DIR}/data/menu.pcx -resize 2048x1496 cydia-package/Applications/Jumpnbump.app/Default-Landscape@2x.png || exit $?
convert iOS-icon-256.png -resize 57x57 cydia-package/Applications/Jumpnbump.app/Icon.png || exit $?
convert iOS-icon-256.png -resize 72x72 cydia-package/Applications/Jumpnbump.app/Icon72.png || exit $?
convert iOS-icon-256.png -resize 114x114 cydia-package/Applications/Jumpnbump.app/Icon@2x.png || exit $?
dpkg-deb -b cydia-package jumpnbump.deb || exit $?

