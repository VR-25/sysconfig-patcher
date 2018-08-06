# Sysconfig Patcher
## (c) 2017-2018, VR25 @ xda-developers
### License: GPL v3+



#### DISCLAIMER

- This software is provided as is, in the hope that it will be useful, but without any warranty. Always read the reference prior to installing/updating. While no cats have been harmed, I assume no responsibility under anything that might go wrong due to the use/misuse of it.
- A copy of the GNU General Public License, version 3 or newer ships with every build. Please, read it prior to using, modifying and/or sharing any part of this work.
- To prevent fraud, DO NOT mirror any link associated with this project.



#### DESCRIPTION

- Systemlessly patches all relevant XML files in /system/etc/sysconfig for data and battery savings & auto-re-patches across ROM/GApps updates. Thus, these packages (i.e., Google Play Services) will no longer have unrestricted access to data & power intensive resources without the user's explicit consent. Doze and data saver will act upon them.



#### SETUP STEPS

1. Remove any/all similar module(s)
2. Install from Magisk Manager or TWRP
3. Reboot



#### ONLINE SUPPORT

- [Git Repository](https://github.com/Magisk-Modules-Repo/sysconfig-patcher)
- [XDA Thread](https://forum.xda-developers.com/apps/magisk/module-sysconfig-patcher-t3668435)



#### RECENT CHANGES

**2018.8.6 (201808060)**
- Fixed issues with MagicGApps & A/B partition devices
- General optimizations

**2018.8.1 (201808010)**
- Better MagicGApps support
- General optimizations
- New and simplified installer
- Striped down (removed unnecessary code & files)
- Updated documentation

**2018.7.24 (201807240)**
- Fixed modPath detection issue (Magisk V16.6).
- Minor optimizations
- Updated documentation
