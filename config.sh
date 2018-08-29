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
POSTFSDATA=false

# Set to true if you need late_start service script
LATESTARTSERVICE=false

##########################################################################################
# Installation Message
##########################################################################################

# Set what you want to show when installing your mod

print_modname() {
  i() { grep_prop $1 $INSTALLER/module.prop; }
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
  for f in $MODPATH/bin/* $MODPATH/system/bin/* $MODPATH/system/xbin/*; do
    [ -f "$f" ] && set_perm $f  0  0  0755
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

  set -ux

  Patched=false
  sysconfigPath0=$MODPATH/system/etc/sysconfig

  $BOOTMODE && MOUNTPATH0=$(sed -n 's/^.*MOUNTPATH=//p' \
    /data/adb/magisk/util_functions.sh | head -n1) \
      || MOUNTPATH0=$MOUNTPATH

  postFsD=$MOUNTPATH0/.core/post-fs-data.d

  curVer=$(grep_prop versionCode $MOUNTPATH0/$MODID/module.prop)
  set +u
  [ -z "$curVer" ] && curVer=0
  set -u

  # create module paths
  { rm -rf $MODPATH
  mkdir -p $sysconfigPath0 "$postFsD"; } 2>/dev/null

  # extract module files
  ui_print "- Extracting module files"
  unzip -o "$ZIP" ${MODID}.sh -d "$postFsD" >&2
  set +u
  set_perm "$postFsD/${MODID}.sh" 0 0 755

  # find system mirror or mount point
  if $BOOTMODE; then
    # find /system mirror
    System=$(dirname $(find /sbin/.core/mirror/system \
      /dev/magisk/mirror/system -type f \
      -name build.prop 2>/dev/null | head -n1) 2>/dev/null)
    [ -f $System/build.prop ] \
      || { echo -e "(!) /system mirror not found\nls: $(ls $System)"; exit 1; }
  else
    System=/system
  fi
  set -u

  # determine simple mount's path
  [ "$(/data/adb/magisk/magisk -V 2>/dev/null)" -gt "1641" ] \
    && simpleMount=/data/adb/magisk_simple \
    || { simpleMount=/cache/magisk_mount; mount -o remount,rw /cache; }

  sysconfigPath=$simpleMount/system/etc/sysconfig
  rmList=$sysconfigPath/spRmList

  # sysconfig file patcher
  patchf() {
    set +u
    for f in $1/*; do
      (if grep -q '\<allow.in.*.save' "$f"; then
        ui_print "  - $(basename $f)"
        sed -i '/<allow.in.*.save/s/<a/<!-- a/' "$f" # patch
        for i in ims teleph downl qualc sony shell; do # whitelist these
          sed -i "/<!-- allow.in.*.save.*$i/s/<!-- a/<a/" "$f"
        done
        chcon 'u:object_r:system_file:s0' "$f"
      fi) &
    done
    wait # for background jobs to finish
    set -u
  }

  # patch sysconfig/*
  if [ "$(cat $modPath/.systemSizeK 2>/dev/null)" \
    != "$(du -s $System | awk '{print $1}')" ] \
    || [ ! -d "$sysconfigPath" -o ! -d "$sysconfigPath0" ]
  then
    mkdir -p $rmList 2>/dev/null \
      && chcon -R 'u:object_r:system_file:s0' $simpleMount
    for f in $System/etc/sysconfig/*; do
      if grep -q '\<allow.in.*.save' "$f"; then
        [ -f "$sysconfigPath/$(basename "$f")" ] \
          && { rm "$sysconfigPath/$(basename "$f")" || :; } \
          || touch "$rmList/$(basename "$f")"
          # save a list of files to be deleted after $MODID is disabled/removed
        cp -f "$f" $sysconfigPath/
      fi
    done
    touch "$rmList/DO_NOT_REMOVE" 2>/dev/null
    ui_print "- Patching"
    patchf $sysconfigPath
    cp -f $sysconfigPath/* $sysconfigPath0/ 2>/dev/null
    Patched=true
    # export /system size for automatic re-patching across ROM/GApps updates
    du -s $System | awk '{print $1}' >$MODPATH/.systemSizeK
  fi

  # detect & re-patch MagicGApps sysconfig/* if necessary
  mgaDir="$(echo $modPath | sed "s/$MODID/MagicGApps/")"
  if [ -d "$mgaDir" ] && ! $Patched; then
    if [ "$(cat $modPath/.magicGAppsSizeK 2>/dev/null)" \
      != "$(du -s $mgaDir | awk '{print $1}')" ]
    then
      ui_print "- Patching"
      patchf $sysconfigPath
      cp -f $sysconfigPath/* $sysconfigPath0/ 2>/dev/null
      # export MagicGApps size for automatic re-patching across ROM/GApps updates
      du -s $mgaDir | awk '{print $1}' >$MODPATH/.magicGAppsSizeK
    fi
  fi

  set +u
}


version_info() {

  set -u

  ui_print " "
  ui_print "  Facebook Support Page: https://facebook.com/VR25-at-xda-developers-258150974794782/"
  ui_print " "

  whatsNew="- Improved compatibility
- Magisk Module Template 1500
- Updated documentation"

  ui_print "  WHAT'S NEW"
  echo "$whatsNew" | \
    while read c; do
      ui_print "  $c"
    done
  ui_print "    "

  grep -q '16\.7' $MAGISKBIN/util_functions.sh \
    && ui_print "  *Note*: a Magisk 16.7 bug causes $MODID to generate empty verbose logs (\"set -x\" doesn't work properly)" \
    && ui_print " "
}
