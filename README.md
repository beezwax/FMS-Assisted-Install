# FMS-Assisted-Install

## Wrapper script for silent installs of FileMaker Server using Assisted Install configuration

This is a self-contained helper script to automate FileMaker Server installs by:

* downloading the installer (if given a URL)
* unzipping the installer (if in .zip format)
* mounting the .dmg (if in .dmg format)
* populating the Assisted Install options defined by the script
* installing FMS using the Assisted install configuration

## INSTALLATION & REQUIREMENTS

Copy the latest version of the `fms_assisted_install.sh` file to the desired directory (assuming current directory here):

* macOS: `sudo curl -o fms_assisted_install.sh https://raw.githubusercontent.com/beezwax/FMS-Assisted-Install/refs/heads/main/fms_assisted_install.sh && sudo chmod +x fms_assisted_install.sh`
* Ubuntu: `sudo curl -o fms_assisted_install https://raw.githubusercontent.com/beezwax/FMS-Assisted-Install/refs/heads/main/fms_assisted_install.sh && sudo chmod +x fms_assisted_install.sh`

Then, edit the Assisted Install options found near the bottom of the script, after the line `cat << EOF > 'Assisted Install.txt'`.

## REFERENCES & RELATED

* About silent installations (macOS): https://help.claris.com/en/server-network-install-setup-guide/content/silent-installation-macos.html
* Assisted install of Claris FileMaker Server: https://support.claris.com/s/article/Assisted-install-of-FileMaker-Server-17-and-later?language=en_US