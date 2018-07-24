# Sysconfig Patcher
## VR25 @ xda-developers


### Disclaimer
- This software is provided as is, in the hope that it will be useful, but without any warranty. Always read the reference prior to installing/updating it. While no cats have been harmed in any way, shape or form, I assume no responsibility under anything that might go wrong due to the use/misuse of it.
- A copy of the GNU General Public License, version 3 or newer is included with every version. Please, read it prior to using, modifying and/or sharing any part of this work.
- To avoid fraud, DO NOT mirror any link associated with the project.


### Description
- Systemlessly patches all relevant XML files in /system/etc/sysconfig for data and battery savings & auto-re-patches across ROM/GApps updates. Takes down GMS Doze immunity.
- If you're familiar with `DozeGMS` or similar module/tweak -- Sysconfig Patcher goes even further than that. In addition to `google.xml`, it also patches any other XML files in `/system/etc/sysconfig` containing battery &/or power white-listed packages. This way, these packages will no longer have unrestricted access to data & power intensive resources without the user's explicit consent.


### SETUP STEPS
- Remove any/all similar module(s)
- Install from Magisk Manager or TWRP
- Reboot


### Online Support
- [Git Repository](https://github.com/Magisk-Modules-Repo/sysconfig-patcher)
- [XDA Thread](https://forum.xda-developers.com/apps/magisk/module-sysconfig-patcher-t3668435)


### Recent Changes

**2018.7.24 (201807240)**
- Fixed modPath detection issue (Magisk V16.6).
- Minor optimizations
- Updated documentation

**2018.3.6 (201803060)**
- Added support for A/B partition devices and MagicGApps module
- Compatible with all major Magisk versions
- General bug fixes & optimizations

**2017.12.3 (201712030)**
- Better & wider compatibility -- from Magisk 12 all the way to 14.5, possibly previous and future versions too
- Patching optimizations
- Updated reference
