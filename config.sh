##########################################################################################
#
# Magisk Module Template Config Script
# by topjohnwu
#
##########################################################################################
##########################################################################################
#
# Instructions:
#
# 1. Place your files into system folder (delete the placeholder file)
# 2. Fill in your module's info into module.prop
# 3. Configure the settings in this file (config.sh)
# 4. If you need boot scripts, add them into common/post-fs-data.sh or common/service.sh
# 5. Add your additional or modified system properties into common/system.prop
#
##########################################################################################

##########################################################################################
# Configs
##########################################################################################

# Set to true if you need to enable Magic Mount
# Most mods would like it to be enabled
AUTOMOUNT=true

# Set to true if you need to load system.prop
PROPFILE=false

# Set to true if you need post-fs-data script
POSTFSDATA=true

# Set to true if you need late_start service script
LATESTARTSERVICE=false

##########################################################################################
# Installation Message
##########################################################################################

# Set what you want to show when installing your mod

print_modname() {
  ui_print " "
  ui_print "$(i name) $(i version)"
  ui_print "$(i author)"
  ui_print " "
}

##########################################################################################
# Replace list
##########################################################################################

# List all directories you want to directly replace in the system
# Check the documentations for more info about how Magic Mount works, and why you need this

# This is an example
REPLACE="
/system/app/Youtube
/system/priv-app/SystemUI
/system/priv-app/Settings
/system/framework
"

# Construct your own list here, it will override the example above
# !DO NOT! remove this if you don't need to replace anything, leave it empty as it is now
REPLACE="
"

##########################################################################################
# Permissions
##########################################################################################

set_permissions() {
  # Only some special files require specific permissions
  # The default permissions should be good enough for most cases

  # Here are some examples for the set_perm functions:

  # set_perm_recursive  <dirname>                <owner> <group> <dirpermission> <filepermission> <contexts> (default: u:object_r:system_file:s0)
  # set_perm_recursive  $MODPATH/system/lib       0       0       0755            0644

  # set_perm  <filename>                         <owner> <group> <permission> <contexts> (default: u:object_r:system_file:s0)
  # set_perm  $MODPATH/system/bin/app_process32   0       2000    0755         u:object_r:zygote_exec:s0
  # set_perm  $MODPATH/system/bin/dex2oat         0       2000    0755         u:object_r:dex2oat_exec:s0
  # set_perm  $MODPATH/system/lib/libart.so       0       0       0644

  # The following is default permissions, DO NOT remove
  set_perm_recursive  $MODPATH  0  0  0755  0644

  # Permissions for executables
  for f in $MODPATH/bin/* $MODPATH/system/bin/* \
    $MODPATH/system/xbin/* $MODPATH/*.sh
  do
    [ -f "$f" ] && set_perm $f 0 0 0755
  done
}

##########################################################################################
# Custom Functions
##########################################################################################

# This file (config.sh) will be sourced by the main flash script after util_functions.sh
# If you need custom logic, please add them here as functions, and call these functions in
# update-binary. Refrain from adding code directly into update-binary, as it will make it
# difficult for you to migrate your modules to newer template versions.
# Make update-binary as clean as possible, try to only do function calls in it.


install_module() {

  # shell behavior
  set -euxo pipefail
  trap debug_exit EXIT

  local f=""
  local system=""
  local utilF=$MAGISKBIN/util_functions.sh
  local sysconfigDir=$MODPATH/system/etc/sysconfig
  local sysconfigDir2=/data/adb/magisk_simple/system/etc/sysconfig

  $BOOTMODE && local MOUNTPATH0=$(sed -n 's/^.*MOUNTPATH=//p' $utilF | head -n 1) \
    || local MOUNTPATH0=$MOUNTPATH

  # remove legacy version
  [ -d $MOUNTPATH0/sp ] && { $BOOTMODE && touch $MOUNTPATH0/sp/remove \
    || rm -rf $MOUNTPATH/sp; }

  # create module paths
  rm -rf $MODPATH 2>/dev/null || true
  mkdir -p $sysconfigDir

  if $BOOTMODE; then
    # find /system mirror
    set +e
    system=$(dirname $(find /sbin/.core/mirror/system \
      -type f -name build.prop -maxdepth 2 2>/dev/null | head -n 1))
    set -e
    if [ ! -f $system/build.prop ]; then
      ui_print " "
      ui_print "(!) /system mirror not found!"
      ui_print "- Try installing from TWRP."
      echo -e "\nls $system: $(ls $system)\n" >&2
      exit 1
    fi
  else
    system=/system
  fi

  ui_print "- Patching"

  # sysconfig/
  for f in $system/etc/sysconfig/*; do
    [ -f "$f" ] && grep -q '\<allow.in.*.save' $f \
      && cp -f $f $sysconfigDir/
  done
  # export /system size for automatic re-patching across ROM/GApps updates
  du -s $system | awk '{print $1}' >$MODPATH/.systemSizeK

  # MagicGApps' sysconfig/
  if [ -d $MOUNTPATH0/MagicGApps ] \
    && [ $(grep_prop versionCode $MOUNTPATH0/MagicGApps/module.prop) -gt 201809230 ]
  then
    cp -f $sysconfigDir2/* $sysconfigDir/
    # export ro.addon.open_version for automatic re-patching across systemless GApps updates
    sed -n 's/.*open_version=//p' ${sysconfigDir2%/*}/g.prop >$MODPATH/.MagicGApps
  fi

  patch_ $sysconfigDir
  set +euxo pipefail
}


debug_exit() {
  local e=$?
  echo -e "\n***EXIT $e***\n"
  set +euxo pipefail
  set
  echo
  echo "SELinux status: $(getenforce 2>/dev/null || sestatus 2>/dev/null)" \
    | sed 's/En/en/;s/Pe/pe/'
  if [ $e -ne 0 ]; then
    unmount_magisk_img
    $BOOTMODE || recovery_cleanup
    set -u
    rm -rf $TMPDIR
  fi 1>/dev/null 2>&1
  exit $e
} 1>&2


patch_() {
  local f=""
  set +u
  for f in $1/*; do
    (f=$f
    if grep -q '\<allow.in.*.save' $f; then
      ui_print "  - ${f##*/}"
      sed -i '/<allow.in.*.save/s/<a/<!-- a/' $f # patch
      for i in ims teleph downl qualc sony shell; do # white-list these
        sed -i "/<!-- allow.in.*.save.*$i/s/<!-- a/<a/" $f
      done
    fi) &
  done
  wait # for background jobs to finish
  set -u
}


# module.prop reader
i() {
  local p=$INSTALLER/module.prop
  [ -f $p ] || p=$MODPATH/module.prop
  grep_prop $1 $p
}


version_info() {

  local c="" whatsNew="- Major optimizations
- Magisk 15.0-17.2 support
- Module ID reverted to <sysconfig-patcher>
- Module template 17000, with extras
- Rebooting twice to apply changes after disabling/re-enabling the module is no longer necessary.
- Support for MagicGApps versions greater than <2018.9.23>
- Updated building and debugging tools
- Updated documentation
---
* Release notes
  - If you have </data/adb/magisk_simple/system/etc/sysconfig/>, remove it with TWRP file manager.
  - Oreo and Pie users (or even users in general) may need to disable Google device administrators for things to work as expected. This rather inconvenient requirement has nothing to do with Sysconfig Patcher. It's a Google thing."

  set -euxo pipefail

  ui_print " "
  ui_print "  WHAT'S NEW"
  echo "$whatsNew" | \
    while read c; do
      ui_print "    $c"
    done
  ui_print " "

  # a note on untested Magisk versions
  if [ ${MAGISK_VER/.} -gt 172 ]; then
    ui_print " "
    ui_print "(i) This Magisk version hasn't been tested by @VR25!"
    ui_print "- If you come across any issue, please report."
    ui_print " "
  fi

  ui_print "  LINKS"
  ui_print "    - Facebook Page: facebook.com/VR25-at-xda-developers-258150974794782/"
  ui_print "    - Git Repository: github.com/Magisk-Modules-Repo/sysconfig-patcher/"
  ui_print "    - XDA Thread: forum.xda-developers.com/apps/magisk/module-sysconfig-patcher-t3668435/"
  ui_print " "
}
