#!/bin/sh

curl -s https://api.github.com/repos/neovim/neovim/releases/latest | jq -r .tag_name
