#!/system/bin/sh
# Sysconfig Patcher (sp)
# Copyright (C) 2017-2018, VR25 @ xda-developers
# License: GPL v3+


umask 022 # default perms (d=rwx-rw-rw, f=rw-r-r)
set -u # exit on unset or null variable/parameter


modId=sp
Patched=false

modPath=$(sed -n 's/^.*MOUNTPATH=//p' \
  /data/adb/magisk/util_functions.sh | head -n1)/$modId

newLog=$modPath/${modId}.log
oldLog=$modPath/${modId}_old.log
sysconfigPath0=$modPath/system/etc/sysconfig


# verbose generator
[ -f "$newLog" ] && mv "$newLog" "$oldLog"
if [ -f $modPath/module.prop -a ! -f $modPath/disable ]; then
  exec &>>"$newLog"
  set -x
fi


# find /system mirror
sysMirror=$(dirname $(find /sbin/.core/mirror/system \
  /dev/magisk/mirror/system -type f \
  -name build.prop 2>/dev/null | head -n1) 2>/dev/null)

[ -f "$sysMirror/build.prop" ] \
  || { echo -e "(!) /system mirror not found\nls: $(ls $sysMirror)"; exit 1; }


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
    (if [ "$2" = "revert" -a -d "$rmList" ]; then
      if [ -f "$rmList/$(basename "$f")" ]; then
        rm "$f" # if $f is in removal list(s)
      else
        if grep -q '\<!-- allow.in.*.save' "$f"; then
          sed -i "/<!-- allow.in.*.save/s/<!-- a/<a/" "$f" # revert patch
          chcon 'u:object_r:system_file:s0' "$f"
        fi
      fi
    else
      if grep -q '\<allow.in.*.save' "$f"; then
        sed -i '/<allow.in.*.save/s/<a/<!-- a/' "$f" # patch
        for i in ims teleph downl qualc sony shell; do # whitelist these
          sed -i "/<!-- allow.in.*.save.*$i/s/<!-- a/<a/" "$f"
        done
        chcon 'u:object_r:system_file:s0' "$f"
      fi
    fi) &
  done
  wait # for background jobs to finish
  set -u
  if [ "$2" = "revert" -a -d "$rmList" ]; then
    rm -rf "$rmList"
    [ -z "$(find $simpleMount -type f 2>/dev/null)" ] && rm -rf "$simpleMount"
  fi
}


# if $modId is not installed, revert patches & self-destruct
if [ ! -f $modPath/module.prop ]; then
  patchf $sysconfigPath revert
  rm $0
  exit 0
fi


# revert patches if $modId is disabled
if [ -f $modPath/disable ]; then
  patchf $sysconfigPath revert
  exit 0
fi


# patch sysconfig/*
if [ "$(cat $modPath/.systemSizeK 2>/dev/null)" \
  != "$(du -s $sysMirror | awk '{print $1}')" ] \
  || [ ! -d "$sysconfigPath" -o ! -d "$sysconfigPath0" ]
then
  mkdir -p $rmList $sysconfigPath0 2>/dev/null \
    && chcon -R 'u:object_r:system_file:s0' $simpleMount
  for f in $sysMirror/etc/sysconfig/*; do
    if grep -q '\<allow.in.*.save' "$f"; then
      [ -f "$sysconfigPath/$(basename "$f")" ] \
        && { rm "$sysconfigPath/$(basename "$f")" || :; } \
        || touch "$rmList/$(basename "$f")"
        # save a list of files to be deleted after $modId is disabled/removed
      cp -f "$f" $sysconfigPath/
    fi
  done
  touch "$rmList/DO_NOT_REMOVE"
  patchf $sysconfigPath
  cp -f $sysconfigPath/* $sysconfigPath0/ 2>/dev/null
  Patched=true
  # export /system size for automatic re-patching across ROM/GApps updates
  du -s $sysMirror | awk '{print $1}' >$modPath/.systemSizeK
fi


# detect & re-patch MagicGApps sysconfig/* if necessary
mgaDir="$(echo $modPath | sed "s/$modId/MagicGApps/")"
if [ -d "$mgaDir" ] && ! $Patched; then
  if [ "$(cat $modPath/.magicGAppsSizeK 2>/dev/null)" \
    != "$(du -s $mgaDir | awk '{print $1}')" ]
  then
    patchf $sysconfigPath
    cp -f $sysconfigPath/* $sysconfigPath0/ 2>/dev/null
    # export MagicGApps size for automatic re-patching across ROM/GApps updates
    du -s $mgaDir | awk '{print $1}' >$modPath/.magicGAppsSizeK
  fi
fi
exit 0
