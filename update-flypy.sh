#!/bin/sh

# Download flypy_Setup_*.exe from http://flypy.ys168.com/
# Run:
#     ./update-flypy.sh flypy_Setup_*.exe

file="$1"

dict="flypy.dict.yaml"

version="$(echo "$file" | grep -o '[0-9][0-9.-]*[0-9]')"

cat > "$dict" <<EOF
# Rime dict
# encoding: utf-8
#
# 小鹤音形 http://flypy.com/
#
# Generated by Zhong Jianxin using $0

---
name: flypy
version: "${version}"
sort: by_weight
use_preset_vocabulary: false
columns:
  - code
  - text
  - weight
encoder:
  rules:
    - length_equal: 2
      formula: "AaAbBaBb"
    - length_equal: 3
      formula: "AaBaCaCb"
    - length_in_range: [4, 10]
      formula: "AaBaCaZa"
...

EOF

7z e -so "$file" '$dataFiles$\main.dmg' \
    | ruby ddime2txt.rb a 啊 \
    | grep -v '$ddcmd([a-z/<]' \
    | grep -v '$ddcmd.*keyboard' \
    | grep -v '' \
    | sed -e 's/\(..*\)$ddcmd(\(.*\),..*)\(..*\)/\1\2\3/' \
    >> "$dict"
