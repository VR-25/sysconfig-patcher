# Sysconfig Patcher
## README.md
### Copyright (C) 2017-2018, VR25 @ xda-developers
#### License: GPL v3+



---
#### DISCLAIMER

This software is provided as is, in the hope that it will be useful, but without any warranty. Always read/reread this reference prior to installing/upgrading. While no cats have been harmed, I assume no responsibility under anything which might go wrong due to the use/misuse of it.

A copy of the GNU General Public License, version 3 or newer ships with every build. Please, read it prior to using, modifying and/or sharing any part of this work.

To prevent fraud, DO NOT mirror any link associated with this project; DO NOT share ready-to-flash builds (zips) online!



---
#### DESCRIPTION

Systemlessly patches all relevant XML files in `/system/etc/sysconfig/` for data and battery savings & auto-re-patches across ROM/GApps updates. Thus, packages listed in these files (i.e., `Google Play Services`) will no longer have unrestricted access to data & power intensive resources without the user's explicit consent. `Doze` and `data saver` will act upon them. Core packages such as `Qualcomm's`, `Download Manager`, `Shell`, etc., are not affected. `MagicGApps` module, versions greater than 2018.9.23 are also supported.



---
#### PRE-REQUISITES

- Magisk 15.0-17.2



---
#### SETUP STEPS

1. Remove any/all similar module(s).
2. Install/upgrade from Magisk Manager or TWRP.
3. Reboot.

Note: Oreo and Pie users (or even users in general) may need to disable Google device administrators for things to work as expected. This rather inconvenient requirement has nothing to do with Sysconfig Patcher. It's a Google thing.



---
#### ONLINE SUPPORT

- [Facebook Page](https://facebook.com/VR25-at-xda-developers-258150974794782/)
- [Git Repository](https://github.com/Magisk-Modules-Repo/sysconfig-patcher/)
- [XDA Thread](https://forum.xda-developers.com/apps/magisk/module-sysconfig-patcher-t3668435/)



---
#### LATEST CHANGES

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

**2018.8.20 (201808200)**
- Full redesign
- *Release notes*: "sp" is the new module ID. If this update is not displayed in Magisk Manager, uninstall the current version. Full support for official Magisk beta builds is back.
