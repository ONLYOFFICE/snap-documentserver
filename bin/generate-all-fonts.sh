#!/bin/bash

export LD_LIBRARY_PATH=$SNAP/var/www/onlyoffice/documentserver/server/FileConverter/bin:$LD_LIBRARY_PATH

TOOLDIR="$SNAP/var/www/onlyoffice/documentserver/server/tools"
INDIR="$SNAP/var/www/onlyoffice/documentserver"
OUTDIR="$SNAP_DATA/var/www/onlyoffice/documentserver"

mkdir -p $OUTDIR/server/FileConverter/bin
mkdir -p $OUTDIR/fonts
mkdir -p $OUTDIR/sdkjs/common/Images

"$TOOLDIR/allfontsgen" --input="$INDIR/core-fonts;$SNAP/usr/share/fonts"  --allfonts-web="$OUTDIR/sdkjs/common/AllFonts.js"  --allfonts="$OUTDIR/server/FileConverter/bin/AllFonts.js"  --images="$OUTDIR/sdkjs/common/Images"   --selection="$OUTDIR/server/FileConverter/bin/font_selection.bin"  --output-web="$OUTDIR/fonts"  --use-system="true"

mkdir -p $OUTDIR/sdkjs/slide/themes
cp -R $INDIR/sdkjs/slide/themes_backup/src $OUTDIR/sdkjs/slide/themes

"$TOOLDIR/allthemesgen" --converter-dir="$INDIR/server/FileConverter/bin" --src="$OUTDIR/sdkjs/slide/themes" --output="$OUTDIR/sdkjs/common/Images"