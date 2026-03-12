# FMS-Assisted-Install

## Wrapper script for silent installs of FileMaker Server using Assisted Install configuration

This is a self-contained helper script to automate FileMaker Server installs by performing the following steps:

* downloading the installer (if given a URL)
* unzipping the installer (if in .zip format)
* mounting the .dmg (if in .dmg format)
* populating the Assisted Install options defined by the script
* installing FMS using the Assisted install configuration

## INSTALLATION & REQUIREMENTS

### CURRENTLY MACOS ONLY

Copy the latest version of the `fms_assisted_install.sh` file to the desired directory (assuming current directory here):

* macOS: `curl -o fms_assisted_install.sh https://raw.githubusercontent.com/beezwax/FMS-Assisted-Install/refs/heads/main/fms_assisted_install.sh && chmod +x fms_assisted_install.sh`
* Ubuntu: `curl -o fms_assisted_install https://raw.githubusercontent.com/beezwax/FMS-Assisted-Install/refs/heads/main/fms_assisted_install.sh && chmod +x fms_assisted_install.sh`

Then, edit the Assisted Install options found near the bottom of the script, after the line `cat << EOF > 'Assisted Install.txt'`.

Be sure not to remove the `EOF` line at the end of options.

Since this file will probably have your server credentials and the recovery pin in it, be sure to delete and/or save the script file in a safe place.

## USAGE

`./fms_assisted_install.sh <url, or path to .zip or .dmg>`


## REFERENCES & RELATED

* About silent installations (macOS): https://help.claris.com/en/server-network-install-setup-guide/content/silent-installation-macos.html
* Assisted install of Claris FileMaker Server: https://support.claris.com/s/article/Assisted-install-of-FileMaker-Server-17-and-later?language=en_US
* Setting personalization properties in Assisted Install.txt: https://help.claris.com/en/pro-network-install-setup-guide/content/setting-personalization-properties.html
