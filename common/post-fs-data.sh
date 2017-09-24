#!/system/bin/sh

# Auto re-patch /system/etc/sysconfig/*
syscfg=/dev/magisk/mirror/system/etc/sysconfig
syscfgTMP=/data/_syscfg
syscfgS=/magisk/MagicGApps/system/etc/sysconfig
MODPATH=${0%/*}

if [ "$(cat $MODPATH/.SCPatch 2>/dev/null)" != "$(du -s /system | sed 's|/system||' | xargs)" ]; then
	cp -rf $syscfg $syscfgTMP
	cd $syscfgTMP
	for file in `ls -1`; do sed -i '/allow/s/<a/<!-- a/' $file; done
	sed -i '/.volta/s/<!-- a/<a/' google.xml
	rm -rf $syscfgS
	mv -f $syscfgTMP $syscfgS
	chmod 755 $syscfgS
	chmod -R 644 $syscfgS
fi
exit 0