#!/bin/sh

version=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest)

# https://qiita.com/htsnul/items/2c7d40af1068cb0d7d2a
normalize_and_encode() (
  json=$(echo $version \
    | sed 's/\\"/\\042/g' \
    | sed 's/"[^"]*"/\n&\n/g' \
    | sed '/^"/!s/ //g' \
    | sed '/^"/{
      s/,/\\054/g
      s/\[/\\133/g
      s/\]/\\135/g
      s/{/\\173/g
      s/}/\\175/g
    }' \
    | tr -d '\n'
  )
  while printf %s "$json" | grep '[[{]' > /dev/null; do
    json=$(printf %s "$json" \
      | sed 's/[[{][^][}{]*[]}]/\n&\n/g' \
      | sed '/^[[{].*[]}]$/{
        s/\\/\\\\/g
        s/,/\\054/g
        s/\[/\\133/g
        s/\]/\\135/g
        s/{/\\173/g
        s/}/\\175/g
      }' \
      | tr -d '\n'
    )
  done
  printf %s "$json"
)

# JSON変形
value=$(normalize_and_encode)
# オブジェクト化
object=$(printf %b "$value" | tr -d '{}' | sed 's/,/\n/g')
# キーの値
value=$(printf %s "$object" | sed -n 's/^"tag_name"://p')
# 文字列化
string=$(printf %b "$(printf %s "$value" | sed 's/"//g')")

echo "$string"

