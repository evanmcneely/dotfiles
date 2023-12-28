# Only for Mac OS
if [ "$(uname)" != "Darwin" ]; then
  exit
fi

# initialize file system ??
#   -- create projects folder
#   -- clone some repos ??

# install om my zsh - https://ohmyz.sh/#install
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# install tools with homebrew
source brew.sh

# mac stuff
source macos.sh

# fonts / colors ??

# link dotfiles
source link.sh
