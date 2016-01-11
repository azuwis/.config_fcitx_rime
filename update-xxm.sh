#!/bin/sh

# Download 小兮码新文件.rar from http://tieba.baidu.com/p/3485999115
# Run:
#     ./update-xxm.sh 小兮码新文件.rar

archive="$1"

name="xxm"
dict="${name}.dict.yaml"

version=$(unrar l "$archive" | awk '/小兮码多多版.txt/ {print $3}' | sed 's/-/\./g')

cat > "$dict" <<EOF
# Rime dict
# encoding: utf-8
#
# 小兮码 http://tieba.baidu.com/p/3485999115
#
# Generated by Zhong Jianxin using $0

---
name: ${name}
version: "${version}"
sort: original
use_preset_vocabulary: false
columns:
  - text
  - code
encoder:
  rules:
    - length_equal: 2
      formula: "AaAbBaBb"
    - length_equal: 3
      formula: "AaAbBaCa"
    - length_in_range: [4, 10]
      formula: "AaBaCaZa"
...
，	,
。	.
、	/
；	;
EOF

unrar -inul p "$archive" 小兮码文件/码表/小兮码多多版.txt \
    | iconv -f UTF16 -t UTF8 \
    | fromdos \
    | sed -e '/config/d' -e 's/ //g' \
          >> "$dict"

unrar -inul p "$archive" 小兮码文件/码表/user2多多版.txt \
    | fromdos \
    | sed -e '/config/d' -e 's/ //g' -e '/\$LAST/d' -e 's/\$LEFT//' \
    | sed -e '/xlaa$/d' -e 's/^\[il\]/[i.]/' \
    | awk '!a[$0]++' \
          >> "$dict"
