# Sysconfig Patcher



---
## LEGAL

Copyright (C) 2017-2019, VR25 @ xda-developers

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.



---
## DISCLAIMER

Always read/reread this reference prior to installing/upgrading this software.

While no cats have been harmed, the author assumes no responsibility for anything that might break due to the use/misuse of it.

To prevent fraud, do NOT mirror any link associated with this project; do NOT share builds (zips)! Share official links instead.



---
## DESCRIPTION

This module patches all relevant XML files from `/system/etc/sysconfig/` for data and battery savings, and auto-repatches these after ROM/GApps updates.

Targeted packages (i.e., `Google Play Services (GMS)`) are deprived of unrestricted access to data and power intensive resources without the user's explicit consent.

`Doze` and `data saver` will act upon these. Core packages such as `Qualcomm's`, `Download Manager`, `Shell`, etc., are excluded by default. 

`MagicGApps` module 2019 is supported.



---
## PREREQUISITES

- Magisk 17-19



---
## SETUP


Install

0. [Optional] Set up /sdcard/.sp_whitelist.txt.
- Use zipFile/common/whitelist.txt as reference.
- Do not remove/blacklist default packages, unless you know exactly what you are doing.
- Reinstall the module to apply new changes.

1. Flash live (e.g., from Magisk Manager) or from custom recovery (e.g., TWRP).


Uninstall

- Use Magisk Manager (app) or Magisk Manager for Recovery Mode (utility).



---
## USAGE

Generally, once the module is installed, you don't have to do anything else.

If you face issues, go to settings > security and try one or all of the following workarounds (a reboot is implied):

- Disable all Google `Device Administrators`.
- Disable all Google `Trust Agents`.
- Disable `Find My Device`.



---
## LINKS

- [Donate](https://paypal.me/vr25xda/)
- [Facebook page](https://facebook.com/VR25-at-xda-developers-258150974794782/)
- [Git repository](https://github.com/Magisk-Modules-Repo/sysconfig-patcher/)
- [Telegram channel](https://t.me/vr25_xda/)
- [Telegram profile](https://t.me/vr25xda/)
- [XDA thread](https://forum.xda-developers.com/apps/magisk/module-sysconfig-patcher-t3668435/)



---
## LATEST CHANGES

**2019.4.6 (201904060)**
- Complete redesign
- Custom whitelist (refer to README.md for details)
- Magisk 17-19 and MagicGApps 2019 support
- Updated documentation

**2018.10.22 (201810220)**
- Major optimizations
- Magisk `15.0-17.2` support
- Module ID reverted to `sysconfig-patcher`
- Module template `17000`, with extras
- Rebooting twice to apply changes after disabling/re-enabling the module is no longer necessary.
- Support for MagicGApps versions greater than `2018.9.23`
- Updated building and debugging tools
- Updated documentation
* Release notes: if you have `/data/adb/magisk_simple/system/etc/sysconfig/`, remove it with TWRP file manager (preferably before upgrading). Oreo and Pie users (or even users in general) may need to disable Google device administrators for things to work as expected. This rather inconvenient requirement has nothing to do with Sysconfig Patcher. It's a Google thing.

**2018.8.29 (201808290)**
- Improved compatibility
- Magisk Module Template 1500
- Updated documentation
