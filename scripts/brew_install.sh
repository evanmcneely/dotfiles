/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install \
    lazydocker \
    cmake \
    ripgrep \
    tree-sitter \
    ninja \
    libtool \
    automake \
    pkg-config \
    gettext \
    curl \
    so \
    node \
    git \
    wget

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
