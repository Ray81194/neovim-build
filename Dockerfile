FROM arm64v8/debian:stable-slim

RUN apt-get update \
    && apt-get install -y \
    bash \
    git \
    ninja-build gettext cmake curl build-essential \
    file \
    && rm -rf /var/lib/apt/lists/*
RUN git clone --branch stable --depth 1 https://github.com/neovim/neovim

WORKDIR /neovim
RUN make CMAKE_BUILD_TYPE=RelWithDebInfo
RUN cd build && cpack -G DEB

CMD ["bash"]

