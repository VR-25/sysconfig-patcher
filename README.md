# Sysconfig Patcher
## Copyright (C) 2017-2018, VR25 @ xda-developers
### License: GPL v3+



#### DISCLAIMER

- This software is provided as is, in the hope that it will be useful, but without any warranty. Always read the reference prior to installing/updating. While no cats have been harmed, I assume no responsibility under anything that might go wrong due to the use/misuse of it.
- A copy of the GNU General Public License, version 3 or newer ships with every build. Please, read it prior to using, modifying and/or sharing any part of this work.
- To prevent fraud, DO NOT mirror any link associated with this project.



#### DESCRIPTION

- Systemlessly patches all relevant XML files in /system/etc/sysconfig for data and battery savings & auto-re-patches across ROM/GApps updates. Thus, these packages (i.e., Google Play Services) will no longer have unrestricted access to data & power intensive resources without the user's explicit consent. Doze and data saver will act upon them. Important packages such as Shell, Qualcomm's, Download Manager, etc., are not affected.



#### SETUP STEPS

1. Remove any/all similar module(s)
2. Install from Magisk Manager or TWRP
3. Reboot



#### ONLINE SUPPORT

- [Git Repository](https://github.com/Magisk-Modules-Repo/sysconfig-patcher)
- [XDA Thread](https://forum.xda-developers.com/apps/magisk/module-sysconfig-patcher-t3668435)



#### LATEST CHANGES

**2018.8.13 (201808130)**
- Fixed "sysMirror not found" on A/B partition devices (i.e., Pixel family)
- General optimizations

**2018.8.11-2 (201808112)**
- General fixes & optimizations

**2018.8.11-1 (201808111)**
- Added support for MagicGApps 2018.8.11
- Fixed "make_ext4fs not found" (devices running Android P)
