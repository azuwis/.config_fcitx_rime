#!/bin/bash
set -eu

cd "$(dirname "$(readlink -f "$0")")"

for i in trime.custom.yaml flypy.*.yaml /usr/share/rime-data/pinyin_simp.*.yaml
do
    adb push "$i" /sdcard/rime/
done

temp_file="$(mktemp)"
sed -e '/- schema:/d' -e '/^schema_list:/a \  - schema: flypy' /usr/share/rime-data/default.yaml > "$temp_file"
adb push "$temp_file" /sdcard/rime/default.yaml
rm "$temp_file"

# adb shell am start -n com.osfans.trime/.Pref
adb shell am broadcast -a com.osfans.trime.deploy
