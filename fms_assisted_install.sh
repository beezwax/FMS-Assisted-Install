#!/bin/sh

# HISTORY
#	2026-03-10 simon_b: created file

# USAGE:
#	fms_assisted_install.sh <url, or file path to installer .zip or .dmg>

#
# Below, just after the `cat` command, is the text that will be used for the Assisted Install settings.
# Edit them to match the needs for your environment.
#

VERSION='0.10, macOS'
TMPPATH='/private/tmp'

set -e

if [[ `whoami` != "root" ]]; then
	echo "Warning: Will need to run as root for installer to work"
fi

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <url, or path to a .zip or .dmg>"
    exit 1
fi

# First parameter is the URL or file path
REF="$1"
PREFIX=${REF:0:4}
FILENAME=$(basename ${REF})		# Works regardless of whether using URL or file path

#echo expr substr $1 5 5

if [ $PREFIX == "http" ]; then
	# TODO: make -k optional
	echo "Downloading from $1"
	pushd $TMPPATH
	FILEDIR=$TMPPATH
	curl -k -O $1
	ISURL=true
	
else
	FILEDIR=$(dirname ${REF})
fi

# Should now have either the downloaded zip/dmg or a path to an installer zip/dmg given by caller
# Do we really have the .zip or .dmg in the expected path?

if [[ -f "$FILEDIR/$FILENAME" ]]; then
	if [[ "$REF" == *.zip ]]; then
		ISZIP=true
	else
		ISZIP = false
	fi
	if [[ "$REF" == *.dmg ]]; then
		ISDMG=true
		FILEDIR='????????'
	else
		ISDMG=false
	fi
else
	echo "Error: File not found at $REF"
	exit 1
fi

if [[ ISZIP ]]; then
	echo "Unzipping installer into $TMPPATH"
	INSTALLDIR=$TMPPATH/${FILENAME%.*}""	# "" to remove suffix
	unzip -d $INSTALLDIR $FILEDIR/$FILENAME
fi

pushd $INSTALLDIR

echo "Replacing the installer's Assisted Install.txt file"
cat << EOF > 'Assisted Install.txt'

[Assisted Install]

License Accepted=1
Organization=
Deployment Options=0
FileMaker Server User=0
Admin Console User=
Admin Console Password=
Admin Console PIN=
Launch Deployment Assistant=1
License Certificate Path=
Skip Dialogs=0
Remove Sample Database=0
Remove Desktop Shortcut=0
Load Previous Configuration=0
Filter Databases=0
Use HTTPS Tunneling=0

EOF

PKG=`ls FileMaker\ Server\ *.pkg`
echo $PKG

echo 'Running the installer'

sudo installer -pkg "$PKG" -target /

popd
popd

echo "Done"
