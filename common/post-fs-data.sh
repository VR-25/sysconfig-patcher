#!/system/bin/sh
# Sysconfig Patcher
# (c) 2017-2018, VR25 @ xda-developers
# License: GPL v3+


modPath=${0%/*}
PATH=/sbin/.core/busybox:/dev/magisk/bin
sysMirror=/sbin/.core/mirror/system
etcPath=$modPath/system/etc
tmpDir=/dev/tmpDir
  
# verbosity engine
newLog=$modPath/sysconfig_patcher_verbose_log.txt
oldLog=$modPath/sysconfig_patcher_verbose_previous_log.txt
[[ -f $newLog ]] && mv $newLog $oldLog
set -x 2>>$newLog

patchf() {
    for file in $1/*; do
      grep -Eq '<allow-in-power-save|<allow-in-data-usage-save' "$file" \
        && sed -i '/allow-in-.*-save/s/<a/<!-- a/' "$file" \
        || rm "$file"
    done
}

[[ -f $sysMirror/build.prop ]] || sysMirror=/dev/magisk/mirror/system
[[ -f $sysMirror/build.prop ]] || { echo -e "(!) sysMirror not found\nls: $(ls $sysMirror)"; exit 1; }

[[ -d $tmpDir ]] && rm -rf $tmpDir


# patch sysconfig/*
if [[ $(cat $modPath/.systemSizeK 2>/dev/null) -ne $(du -s $sysMirror | awk '{print $1}') || ! -d $etcPath ]]; then
  mkdir $tmpDir
  cp -R $sysMirror/etc/sysconfig $tmpDir
	
  patchf $tmpDir/sysconfig
	
  rm -rf $modPath/system/etc/sysconfig
  [[ -d $etcPath ]]  || mkdir -p $etcPath
  mv $tmpDir/sysconfig $etcPath/
  chmod -R 755 $etcPath
  chmod 644 $etcPath/*
  
  # export /system size info for automatic re-patching across ROM/GApps updates
  du -s $sysMirror | awk '{print $1}' >$modPath/.systemSizeK
fi


# detect & patch MagicGApps sysconfig/*
cd ..
if [[ -d $PWD/MagicGApps ]]; then
  if [[ $(cat $modPath/.MagicGAppsSizeK 2>/dev/null) -ne $(du -s $PWD/MagicGApps | awk '{print $1}') ]]; then
    patchf $PWD/MagicGApps/system/etc/sysconfig
    chmod 644 $PWD/MagicGApps/system/etc/sysconfig/*
    du -s $PWD/MagicGApps | awk '{print $1}' >$modPath/.MagicGAppsSizeK
  fi
fi

exit 0
