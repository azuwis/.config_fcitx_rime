#!/bin/bash
set -eu

cd "$(dirname "$(readlink -f "$0")")"

for i in trime.custom.yaml flypy_yinxing*.yaml /usr/share/rime-data/pinyin_simp.*.yaml /usr/share/rime-data/default.yaml
do
    adb push "$i" /sdcard/rime/
done

adb shell sed -i -e '/- schema:/d' -e '/^schema_list:/a \  - schema: flypy_yinxing' /sdcard/rime/default.yaml
