#!/bin/bash
set -eu

cd "$(dirname "$(readlink -f "$0")")"

adb shell mkdir -p /sdcard/rime/

for i in double_pinyin_c.schema.yaml aurora_pinyin.dict.yaml zhwiki.dict.yaml tongwenfeng.trime.custom.yaml
do
    adb push "$i" /sdcard/rime/
done

temp_file="$(mktemp)"
sed -e '/- schema:/d' -e '/^schema_list:/a \  - schema: double_pinyin_c' /usr/share/rime-data/default.yaml > "$temp_file"
adb push "$temp_file" /sdcard/rime/default.yaml
rm "$temp_file"

# adb shell am start -n com.osfans.trime/.Pref
#adb shell 'unzip -p "$(pm path com.osfans.trime | cut -d : -f 2)" assets/rime/trime.yaml > /sdcard/rime/trime.yaml'
adb shell 'unzip -p "$(pm path com.osfans.trime | cut -d : -f 2)" assets/rime/tongwenfeng.trime.yaml > /sdcard/rime/tongwenfeng.trime.yaml'
adb shell am broadcast -a com.osfans.trime.deploy
