# FMS-Assisted-Install

## Wrapper script for silent installs of FileMaker Server using Assisted Install configuration

This is a self-contained helper script to automate FileMaker Server installs by performing the following steps:

* downloading the installer (if given a URL)
* unzipping the installer (if in .zip format)
* mounting the .dmg (if in .dmg format)
* populating the Assisted Install options defined by the script
* installing FMS using the Assisted install configuration

## INSTALLATION & REQUIREMENTS

### CURRENTLY MACOS & UBUNTU ONLY

Copy the latest version of the `fms_assisted_install.sh` file to the desired directory (assuming current directory here):

* macOS: `curl -o fms_assisted_install.sh https://raw.githubusercontent.com/beezwax/FMS-Assisted-Install/refs/heads/main/fms_assisted_install.sh && chmod +x fms_assisted_install.sh`
* Ubuntu: `curl -o fms_assisted_install.sh https://raw.githubusercontent.com/beezwax/FMS-Assisted-Install/refs/heads/main/fms_assisted_install.sh && chmod +x fms_assisted_install.sh`

UBUNTU: The `unzip` command must be available. To install, run `sudo apt install unzip`.

Then, edit the Assisted Install options found near the bottom of the script, after the line `cat << EOF > 'Assisted Install.txt'`.

Be sure not to remove the `EOF` line at the end of options.

### Post Install

Since this file will probably have your server credentials and the recovery pin in it, be sure to delete and/or save the script file in a safe place.

Some files are currently left in the /tmp directory. These will remain until eventually cleared by the OS, so you may want to clear these up manually. If doing a re-install of the same version,
and the .zip or .dmg is still present, you could use a path to the previously downloaded file instead re-downloading, eg:

`./fms_assisted_install.sh /tmp/fms_22.0.6.202.dmg`

## USAGE

`./fms_assisted_install.sh <url, or path to .zip or .dmg>`

Above assumes executing from the same directory as the script.

These two options are available:

* [ --ai-path | -a <aipath> ] -- use the file at given path for the Assisted Install values
* [ --update | -U ] -- on Ubuntu, run `apt-get update` before starting installer

If using the built-in Assisted Install text, some fields can be set via options:

* [ --deployment | -d <options> ] -- set 'Deployment Options' field
* [ --filter | -f ] -- set 'Filter Databases' field
* [ --license | -l <path> ] -- set 'License Certificate Path' field
* [ --organization | -o <name> ] -- set 'Organization' field
* [ --password | -p <password> ] -- set 'Admin Console Password' field
* [ --pin | -n <pin> ] -- set 'Admin Console PIN' field
* [ --previous | -P ] -- set 'Load Previous Configuration' field
* [ --rm-sample | -r ] -- set 'Remove Sample Database' field
* [ --rm-shortcut | -s ] -- set 'Remove Desktop Shortcut' field
* [ --skip | -s ] -- set 'Skip Dialogs' field
* [ --tunneling | -t ] -- set 'Use HTTPS Tunneling' field
* [ --user | -u <account> ] -- set 'Admin Console User' field

## REFERENCES & RELATED

* About silent installations (macOS): https://help.claris.com/en/server-network-install-setup-guide/content/silent-installation-macos.html
* Assisted install of Claris FileMaker Server: https://support.claris.com/s/article/Assisted-install-of-FileMaker-Server-17-and-later?language=en_US
* Setting personalization properties in Assisted Install.txt: https://help.claris.com/en/pro-network-install-setup-guide/content/setting-personalization-properties.html
* Running FileMaker Server in a Docker container for Ubuntu 20.04: https://support.claris.com/s/article/Running-FileMaker-Server-in-a-Docker-container-for-Ubuntu-20-04?language=en_US
