#!/bin/bash
set -eu

cd "$(dirname "$(readlink -f "$0")")"

adb shell mkdir -p /sdcard/rime/
adb shell rm -rf /sdcard/rime/build/

for i in \
  *.dict.yaml \
  /usr/share/rime-data/key_bindings.yaml \
  /usr/share/rime-data/punctuation.yaml \
  /usr/share/rime-data/symbols.yaml \
  double_pinyin_c.custom.yaml \
  double_pinyin_c.schema.yaml \
  grammar.yaml \
  tongwenfeng.trime.custom.yaml \
  zh-hans-t-essay-bgw.gram
do
    adb push "$i" /sdcard/rime/
done

temp_file="$(mktemp)"
sed -e '/- schema:/d' -e '/^schema_list:/a \  - schema: double_pinyin_c' -e 's/^  page_size: .*/  page_size: 10/' /usr/share/rime-data/default.yaml > "$temp_file"
adb push "$temp_file" /sdcard/rime/default.yaml
rm "$temp_file"

# adb shell am start -n com.osfans.trime/.Pref
# To make opencc work, Input -> Reset -> opencc
adb shell 'unzip -p "$(pm path com.osfans.trime | cut -d : -f 2)" assets/rime/trime.yaml > /sdcard/rime/trime.yaml'
adb shell 'unzip -p "$(pm path com.osfans.trime | cut -d : -f 2)" assets/rime/tongwenfeng.trime.yaml > /sdcard/rime/tongwenfeng.trime.yaml'
adb shell am broadcast -a com.osfans.trime.deploy
