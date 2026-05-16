#!/bin/bash

# HISTORY
#	2026-03-10 simon_b: created file

# USAGE:
#	fms_assisted_install.sh <url, or file path to installer .zip or .dmg>
#		-a	use assisted install file at the specified path
#		-u  on Ubuntu, run apt-get update before installing

#
# Below, just after the `cat` command, is the text that will be used for the Assisted Install settings.
# Edit them to match the needs for your environment.
#

set -e

VERSION='0.14, macOS/Ubuntu'

REF="$1"
AIPATH=""
ARCHIVEPREFIX=${REF:0:4}
ARCHIVEFILE=$(basename ${REF})		# Works regardless of whether using URL or file path
ISDMG=false
UPDATEAPT=false


# Process command line args, which may override some of the above variables.

POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
	case $1 in
		-a|--ai-path)
			AIPATH="$2"
			shift # past argument
			shift # past value
			;;
		-U|--update)
			UPDATEAPT=true
			shift # past argument
			;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done

# Restore positional parameters
set -- "${POSITIONAL_ARGS[@]}"


if [[ "$OSTYPE" == "darwin"* ]]; then
	ISMACOS=true
else
	ISMACOS=false
fi

if [ $ISMACOS = true ]; then
	TMPPATH='/private/tmp'
else
	TMPPATH='/tmp'
	if ! type "unzip" > /dev/null; then
		echo "The unzip command is required, install with: sudo apt install unzip"
		exit 4
	fi
	if [ $UPDATEAPT = true ]; then
		echo "Running apt-get update"
		sudo apt-get update
		echo
	fi
fi

if [ $AIPATH != "" ]; then
	if [[ -f "$AIPATH" ]]; then
		cp "$AIPATH" "$TMPPATH/Assisted Install.txt"
	else
		echo "Error: The Assisted Install file doesn't exist at $AIPATH"
		exit 5
	fi
fi

if [[ `whoami` != "root" ]]; then
	echo "Warning: Will need to run as root for installer to work"
fi

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <url, or path to a .zip or .dmg>"
    exit 1
fi

if [ $ARCHIVEPREFIX == "http" ]; then
	# TODO: make -k optional
	echo "Downloading installer from $1"
	pushd $TMPPATH
	ARCHIVEDIR=$TMPPATH
	curl -k -O $1
	ISURL=true
	popd
else
	ARCHIVEDIR=$(dirname ${REF})
fi

# Should now have either the downloaded zip, or a path to either a dmg or zip.
# (but not the actual installer file yet)

if [[ -f "$ARCHIVEDIR/$ARCHIVEFILE" ]]; then	# Really have the .zip or .dmg?

	if [[ "$ARCHIVEFILE" == *.zip ]]; then
		
		PKGDIR=$TMPPATH/${ARCHIVEFILE%.*}""	# "" to remove suffix
		if [[ -d "$PKGDIR" ]]; then
			echo "Deleting previous copy of install files"
			rm -r "$PKGDIR"		# may have hidden files, so we delete the entire dir
		fi
		echo "Unzipping installer into $PKGDIR"
		unzip -d $PKGDIR $ARCHIVEDIR/$ARCHIVEFILE
		pushd $PKGDIR
		
		if [ $ISMACOS = true ]; then
			PKGFILE=`ls FileMaker\ Server\ *.pkg`
		else
			PKGFILE=`ls filemaker-server*.deb`
		fi

	elif [[ "$ARCHIVEFILE" == *.dmg ]]; then
	
		if [ $ISMACOS = true ]; then

			ISDMG=true
			PKGDIR="$TMPPATH"
			echo "Mounting the DMG"
			DMGDIR=`hdiutil attach "$ARCHIVEDIR/$ARCHIVEFILE" | grep -o "/Volumes/.*"`
			pushd "$DMGDIR"
			PKGFILE=`ls FileMaker\ Server\ *.pkg`
			popd
			# The Assisted Install.txt file needs to be writeable, so we can't use the mounted DMG.
			# To avoid having to copy the .pkg we'll symlink to it in the tmp directory instead.
			pushd $PKGDIR
			ln -f -s "$DMGDIR/$PKGFILE"

		else
		
			echo "Error: .dmg installers not supported on Ubuntu"
			exit 3

		fi
		
	else

		echo "Error: Don't have the expected .zip or .dmg path"
		exit 2

	fi
fi

# We are now in $PKGDIR, which contains (or has a symlink to) the needed pkg/deb file.
# Still need the custom Assisted Install.txt file .

echo "Creating the custom Assisted Install.txt file"

###########################################################

cat << EOF > 'Assisted Install.txt'

[Assisted Install]

License Accepted=1
Organization=
Deployment Options=0
FileMaker Server User=0
Admin Console User=
Admin Console Password=
Admin Console PIN=
Launch Deployment Assistant=0
License Certificate Path=
Skip Dialogs=0
Remove Sample Database=0
Remove Desktop Shortcut=0
Load Previous Configuration=0
Filter Databases=0
Use HTTPS Tunneling=0

# Ubuntu Only
Security Check=1
Swap File Size=0
Swappiness=10
Preserve Firewall=0

EOF

# o|organization: Organization
# d|deployment: Deployment Options
# u|user: Admin Console User
# p|password: Admin Console Password
# n|pin: Admin Console PIN
# l|license: License Certificate Path
# s|skip: Skip Dialogs
# r|rm-sample: Remove Sample Database
# s|rm-shortcut: Remove Desktop Shortcut
# P|previous: Load Previous Configuration
# f|filter: Filter Databases
# t|tunneling: Use HTTPS Tunneling

###########################################################


echo 'Running the installer'

if [ $ISMACOS = true ]; then
	sudo installer -pkg "$PKGFILE" -target /
else
	sudo FM_ASSISTED_INSTALL="$PKGDIR/Assisted Install.txt" apt install "$PKGDIR/$PKGFILE"
fi

popd

if [ $ISDMG = true ]; then
	echo "Detaching the DMG"
	hdiutil detach "$DMGDIR"
fi

echo "Done"

# TODO: optionally clean up or leave installer files here?
