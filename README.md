# Sysconfig Patcher
## VR25 @ xda-developers


### Disclaimer
- This mod is provided as is, without warranty of any kind. I shall not be held responsible for anything that may go wrong due to the use/misuse of it.


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

**2018.3.6 (201803060)**
- Added support for A/B partition devices and MagicGApps module
- Compatible with all major Magisk versions
- General bug fixes & optimizations

**2017.12.3 (201712030)**
- Better & wider compatibility -- from Magisk 12 all the way to 14.5, possibly previous and future versions too
- Patching optimizations
- Updated reference

**2017.11.9 (201711090)**
- General optimizations
