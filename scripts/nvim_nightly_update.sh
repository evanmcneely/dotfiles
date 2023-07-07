# Get updates
cd ~/dev/neovim
git pull origin master

# Compile the source
make distclean && make CMAKE_BUILD_TYPE=Release
