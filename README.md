# Sysconfig Patcher (sp)
## Copyright (C) 2017-2018, VR25 @ xda-developers
### License: GPL v3+



---
#### DISCLAIMER

- This software is provided as is, in the hope that it will be useful, but without any warranty. Always read the reference prior to installing/updating. While no cats have been harmed, I assume no responsibility under anything that might go wrong due to the use/misuse of it.
- A copy of the GNU General Public License, version 3 or newer ships with every build. Please, read it prior to using, modifying and/or sharing any part of this work.
- To prevent fraud, DO NOT mirror any link associated with this project.



---
#### DESCRIPTION

- Systemlessly patches all relevant XML files in /system/etc/sysconfig for data and battery savings & auto-re-patches across ROM/GApps updates. Thus, these packages (i.e., Google Play Services) will no longer have unrestricted access to data & power intensive resources without the user's explicit consent. Doze and data saver will act upon them. Important packages such as Shell, Qualcomm's, Download Manager, etc., are not affected. MagicGApps module is also supported.



---
#### PRE-REQUISITES

- Magisk v15+



---
#### SETUP STEPS

1. Remove any/all similar module(s)
2. Install from Magisk Manager or TWRP
3. Reboot

Note: after disabling/re-enabling the module, changes take effect only after two reboots. This is not a bug nor can it be solved at this point (Magisk's limitation).



---
#### ONLINE SUPPORT

- [Facebook Support Page](https://facebook.com/VR25-at-xda-developers-258150974794782)
- [Git Repository](https://github.com/Magisk-Modules-Repo/sysconfig-patcher)
- [XDA Thread](https://forum.xda-developers.com/apps/magisk/module-sysconfig-patcher-t3668435)



---
#### LATEST CHANGES

**2018.8.29 (201808290)**
- Improved compatibility
- Magisk Module Template 1500
- Updated documentation

**2018.8.20 (201808200)**
- Full redesign
- *Release notes*: "sp" is the new module ID. If this update is not displayed in Magisk Manager, uninstall the current version. Full support for official Magisk beta builds is back.

**2018.8.14 (201808140)**
- Fixed install failure from MM (Android P, Magisk 16.7)
- Misc fixes and optimizations
