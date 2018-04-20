#!/bin/sh

# Download 键道音笔*.rar from http://daniushuangpin.ys168.com/
# Unpack to get JDYBsetup*.exe
# Run:
#     ./jdyb.sh JDYBsetup*.exe

file="$1"

dict="jdyb.dict.yaml"

version="$(stat -c %y "$file" | cut -d' ' -f1 | tr '-' '.')"

cat > "$dict" <<EOF
# Rime dict
# encoding: utf-8
#
# 键道音笔 http://daniushuangpin.ys168.com/
#
# Generated by Zhong Jianxin using $0

---
name: jdyb
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
    | ruby ddime2txt.rb '%{code}	%{text}	%{weight}' \
    | grep -v '$ddcmd([a-z/<]' \
    | grep -v '$ddcmd.*keyboard' \
    | grep -v '
    | sed -e 's/\(..*\)$ddcmd(\(.*\),..*)/\1\2/' \
    >> "$dict"