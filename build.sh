#!/bin/bash

scriptDir=$(cd $(dirname $0) && pwd)

docker build -t neovim-build ${scriptDir}
docker run -d --name neovim-build neovim-build

docker cp neovim-build:/neovim/build/nvim-linux-arm64.deb ./nvim-linux-arm64.deb
docker rm -f neovim-build
docker rmi neovim-build
