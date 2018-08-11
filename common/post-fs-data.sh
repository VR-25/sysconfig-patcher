#!/system/bin/sh
# Sysconfig Patcher
# Copyright (C) 2017-2018, VR25 @ xda-developers
# License: GPL v3+


modPath=${0%/*}
newLog=$modPath/sysconfig_patcher_verbose_log.txt
oldLog=$modPath/sysconfig_patcher_verbose_previous_log.txt

# verbose generator
[ -f "$newLog" ] && mv $newLog $oldLog
set -x 2>>$newLog

TMPDIR=/dev/tmp
etcPath=$modPath/system/etc

system=/system
[ -d /system_root ] && system=/system_root/system
sysMirror=/sbin/.core/mirror$system

[ -f "$sysMirror/build.prop" ] || sysMirror=/dev/magisk/mirror$system
[ -f "$sysMirror/build.prop" ] || { echo -e "(!) sysMirror not found\nls: $(ls $sysMirror)"; exit 1; }

patchf() {
    for f in $1/*; do
      grep -Eq '<allow-in-power-save|<allow-in-data-usage-save' "$f" \
        && sed -i "/$(grep 'allow-in-.*-save' "$f" | grep -iv 'ims|telep|downl|qualc|sony|shell')/s/<a/<!-- a/" "$f" \
        || { [ -z "$2" ] && rm "$f"; }
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
if [ -d "$mgaDir" ]; then
  if [ "$(cat $modPath/.MagicGAppsSizeK 2>/dev/null)" != "$(du -s $mgaDir | awk '{print $1}')" ]; then
    patchf $mgaDir/system/etc/sysconfig noremove
    chmod 644 $mgaDir/system/etc/sysconfig/*
    chcon 'u:object_r:system_file:s0' $mgaDir/system/etc/sysconfig/*
    du -s $mgaDir | awk '{print $1}' >$modPath/.MagicGAppsSizeK
  fi
fi

exit 0
