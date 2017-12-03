#!/system/bin/sh
# Auto re-patch /system/etc/sysconfig/* across ROM/GApps updates
# VR25 @ XDA Developers

# Environment
ModPath=${0%/*}
export PATH=$PATH:/sbin/.core/busybox:/dev/magisk/bin
sysmirror=/sbin/.core/mirror/system
[ -d $sysmirror ] || sysmirror=/dev/magisk/mirror/system
syscfg=$sysmirror/etc/sysconfig
syscfgTMP=/data/_syscfg
syscfgP=$ModPath/system/etc/sysconfig

if [ "$(cat $ModPath/.SystemSizeK)" -ne "$(du -s $sysmirror | cut -f1)" ]; then
	[ -d "$syscfgTMP" ] && rm -rf $syscfgTMP
	mkdir $syscfgTMP
	rm -rf $syscfgP/*
	
	for file in $syscfg/*; do
		if [ -f "$file" ]; then
			grep -Eq '<allow-in-power-save|<allow-in-data-usage-save' "$file" \
				&& cp "$file" $syscfgTMP || cp "$file" $syscfgP
		fi
	done
	
	for file in $syscfgTMP/*; do
		[ -f "$file" ] && sed -i '/allow-in-.*-save/s/<a/<!-- a/' "$file"
	done
	
	sed -i '/.volta/s/<!-- a/<a/' $syscfgTMP/google.xml
	cp $syscfgTMP/* $syscfgP
	rm -rf $syscfgTMP
	chmod -R 644 $syscfgP
	echo "$(du -s $sysmirror | cut -f1)" > $ModPath/.SystemSizeK
fi
exit 0