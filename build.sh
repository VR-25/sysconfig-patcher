#!/usr/bin/env bash
# Flashable zip builder
# Copyright (C) 2018-2019, VR25 @ xda-developers
# License: GPLv3+

echo
get_value() { sed -n "s/^$1=//p" module.prop; }
set_value() { sed -i "s/^$1=.*/$1=$2/" module.prop; }

cd ${0%/*} 2>/dev/null

version=$(grep '\*\*.*\(.*\)\*\*' README.md \
  | head -n1 | sed 's/\*\*//; s/ .*//')

versionCode=$(grep '\*\*.*\(.*\)\*\*' README.md \
  | head -n1 | sed 's/\*\*//g; s/.* //' | tr -d ')' | tr -d '(')

set_value version $version
set_value versionCode $versionCode

mkdir -p _builds

zip -r9u _builds/$(get_value id)-$(get_value versionCode).zip \
  * .gitattributes .gitignore \
  -x _*/* | grep .. && echo
