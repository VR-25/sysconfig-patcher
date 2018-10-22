#!/system/bin/sh
# Sysconfig Re-patcher
# Copyright (C) 2017-2018, VR25 @ xda-developers
# License: GPL v3+


main() {

  # shell behavior
  set -euo pipefail
  trap debug_exit EXIT

  local f=""
  local repatch=false
  local systemMirror=""
  local sysconfigDir=${0%/*}/system/etc/sysconfig
  local sysconfigDir2=/data/adb/magisk_simple/system/etc/sysconfig
  local magicGAppsDir=$(echo ${0%/*} | sed s/sysconfig-patcher/MagicGApps/)

  # log
  [ -f ${0%/*}/post-fs-data.sh.log ] \
    && mv ${0%/*}/post-fs-data.sh.log ${0%/*}/post-fs-data.sh.log.old
  exec 1>${0%/*}/post-fs-data.sh.log 2>&1
  set -x

  systemMirror=$(dirname $(find /sbin/.core/mirror/system \
    -type f -name build.prop -maxdepth 2 2>/dev/null | head -n 1))

  # system sysconfig/*
  if [ ! -d $sysconfigDir ] \
    || [ $(cat ${0%/*}/.systemSizeK) -ne $(du -s $systemMirror | awk '{print $1}') ]
  then
    repatch=true
    rm -rf $sysconfigDir 2>/dev/null || true
    mkdir -p $sysconfigDir
    for f in $systemMirror/etc/sysconfig/*; do
      [ -f "$f" ] && grep -q '\<allow.in.*.save' $f \
        && cp -af $f $sysconfigDir/
    done
    # export /system size for automatic re-patching across ROM/GApps updates
    du -s $systemMirror | awk '{print $1}' >${0%/*}/.systemSizeK
  fi

  # MagicGApps sysconfig/*
  if [ -d $magicGAppsDir ] \
    && [ $(sed -n s/versionCode=//p $magicGAppsDir/module.prop) -gt 201809230 ] \
    && [ $(cat ${0%/*}/.MagicGApps) -ne $(sed -n 's/.*open_version=//p' ${sysconfigDir2%/*}/g.prop) ]
  then
    repatch=true
    cp -af $sysconfigDir2/* $sysconfigDir/
    # export ro.addon.open_version for automatic re-patching across systemless GApps updates
    sed -n 's/.*open_version=//p' ${sysconfigDir2%/*}/g.prop >${0%/*}/.MagicGApps
  fi

  $repatch && patch_ $sysconfigDir || true
}


debug_exit() {
  local e=$?
  echo -e "\n***EXIT $e***\n"
  set +euxo pipefail
  set
  echo
  echo "SELinux status: $(getenforce || sestatus)" \
    | sed 's/En/en/;s/Pe/pe/'
  exit $e
} 2>/dev/null


patch_() {
  local f=""
  for f in $1/*; do
    (f=$f
    if grep -q '\<allow.in.*.save' $f; then
      sed -i '/<allow.in.*.save/s/<a/<!-- a/' $f # patch
      for i in ims teleph downl qualc sony shell; do # white-list these
        sed -i "/<!-- allow.in.*.save.*$i/s/<!-- a/<a/" $f
      done
    fi) &
  done
  wait # for background jobs to finish
  chcon -R 'u:object_r:system_file:s0' $1
  chown -R 0:0 $1
  chmod -R 0644 $1
}


main
exit $?
