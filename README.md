# Sysconfig Patcher
# VR25 @ XDA Developers

- Takes down GMS Doze "imunity".
- Systemlessly patches all relevent XML files in `/system/etc/sysconfig` for data and battery savings -- & auto-re-patches across ROM/GApps updates.

- If you're familiar with `DozeGMS` or similar module/tweak -- Sysconfig Patcher goes even further than that. In addition to `google.xml`, it also patches any other XML files in `/system/etc/sysconfig` containing battery &/or power white-listed packages. This way, these packages will no longer have unrestricted access to data & power intensive resources without the user's explicit consent.

- Remove any similar mod before installing.

**Online Support**
- [Git Repository](https://github.com/Magisk-Modules-Repo/sysconfig-patcher)
- [XDA Thread](https://forum.xda-developers.com/apps/magisk/module-sysconfig-patcher-t3668435)