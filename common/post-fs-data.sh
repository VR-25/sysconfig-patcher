#!/system/bin/sh
# Sysconfig Patcher
# Copyright (C) 2017-2018, VR25 @ xda-developers
# License: GPL v3+


modPath=${0%/*}
newLog=$modPath/sp_log.txt
oldLog=$modPath/sp_previous_log.txt

umask 022
set -u

# verbose generator
[ -f "$newLog" ] && mv $newLog $oldLog
set -x 2>>$newLog

TMPDIR=/dev/tmp
etcPath=$modPath/system/etc

sysMirror="$(dirname "$(find /sbin/.core/mirror/system /dev/magisk/mirror/system -type f -name build.prop 2>/dev/null | head -n1)")"

[ -f "$sysMirror/build.prop" ] || { echo -e "(!) sysMirror not found\nls: $(ls $sysMirror)"; exit 1; }

patchf() {
    for f in $1/*; do
      (if grep -q '\<allow.in.*.save' "$f"; then
        sed -i '/<allow.in.*.save/s/<a/<!-- a/' "$f"
        for i in ims teleph downl qualc sony shell; do
          sed -i "/<!-- allow.in.*.save.*$i/s/<!-- a/<a/" "$f"
        done
      else
        set +u
        [ -z "$2" ] && rm "$f"
        set -u
      fi) &
    done
}


# patch sysconfig/*
if [ "$(cat $modPath/.systemSizeK 2>/dev/null)" != "$(du -s $sysMirror | awk '{print $1}')" -o ! -d "$etcPath/sysconfig" ]; then
  mkdir $TMPDIR
  cp -R $sysMirror/etc/sysconfig $TMPDIR

  patchf $TMPDIR/sysconfig

  rm -rf $etcPath/sysconfig 2>/dev/null
  mkdir -p $etcPath 2>/dev/null
  mv $TMPDIR/sysconfig $etcPath/
  chmod -R 755 $etcPath
  chmod 644 $etcPath/sysconfig/*
  chcon 'u:object_r:system_file:s0' $etcPath/sysconfig/*
  set -u
  rm -rf $TMPDIR
  set +u

  # export /system size for automatic re-patching across ROM/GApps updates
  du -s $sysMirror | awk '{print $1}' >$modPath/.systemSizeK
fi


# detect & patch MagicGApps sysconfig/*
mgaDir="$(echo $modPath | sed 's/sysconfig-patcher/MagicGApps/')"
sysconfigPath2=/data/adb/magisk_simple/system/etc/sysconfig
sysconfigPath3=/cache/magisk_mount/system/etc/sysconfig
if [ -d "$mgaDir" ]; then
  if [ "$(cat $modPath/.magicGAppsSizeK 2>/dev/null)" != "$(du -s $mgaDir | awk '{print $1}')" ]; then
    patchf $mgaDir/system/etc/sysconfig noremove
    chmod 644 $mgaDir/system/etc/sysconfig/*
    chcon 'u:object_r:system_file:s0' $mgaDir/system/etc/sysconfig/*
    cp -af $mgaDir/system/etc/sysconfig/* $sysconfigPath2/
    cp -af $mgaDir/system/etc/sysconfig/* $sysconfigPath3/
    du -s $mgaDir | awk '{print $1}' >$modPath/.magicGAppsSizeK
  fi

  if [ ! -f $sysconfigPath2/google.xml ]; then
    mkdir -p $sysconfigPath2 2>/dev/null
    cp -af $mgaDir/system/etc/sysconfig/* $sysconfigPath2/
  fi

  if [ ! -f $sysconfigPath3/google.xml ]; then
    mkdir -p $sysconfigPath3 2>/dev/null
    [ -d "$sysconfigPath3" ] && cp -af $mgaDir/system/etc/sysconfig/* $sysconfigPath3/
  fi

fi

exit 0
