#!/system/bin/sh
# Automatically re-patch /system/etc/sysconfig/* across ROM/GApps updates
# VR25 @ xda-developers


# Environment
ModPath=${0%/*}
export PATH="/sbin/.core/busybox:/dev/magisk/bin:$PATH"
SysPaths="/sbin/.core/mirror/system
/dev/magisk/mirror/system"
rm -rf /dev/syscfgp_tmp 2>/dev/null


for p in $SysPaths; do
	if [ $p/build.prop ]; then
		SysPath="$p"
		break
	fi
done


if [ "$(cat $ModPath/.SystemSizeK)" -ne "$(du -s $SysPath | cut -f1)" ]; then
	mkdir /dev/syscfgp_tmp
	cp -R $SysPath/etc/sysconfig /dev/syscfgp_tmp
	
	# Detect MagicGApps
	FoundMGA="$(find /sbin/.core/img /magisk -type d -name MagicGApps 2>/dev/null | head -n1)"
	echo "$FoundMGA" | grep -q '/MagicGApps$' && cp -a "$FoundMGA"/etc/sysconfig/* /dev/syscfgp_tmp/sysconfig 2>/dev/null
	
	for file in /dev/syscfgp_tmp/sysconfig/*; do
		if [ -f "$file" ]; then
			if grep -Eq '<allow-in-power-save|<allow-in-data-usage-save' "$file"; then
				sed -i '/allow-in-.*-save/s/<a/<!-- a/' $file
			else
				rm "$file"
			fi
		fi
	done
	sed -i '/.volta/s/<!-- a/<a/' /dev/syscfgp_tmp/sysconfig/google.xml

	rm -rf $ModPath/system/etc/sysconfig
	mv /dev/syscfgp_tmp/sysconfig $ModPath/system/etc/
  chmod -R 755 $ModPath

	# Export /system size info for automatic re-patching across ROM/GApps updates
	du -s $SysPath | cut -f1 >$ModPath/.SystemSizeK
fi
exit 0
