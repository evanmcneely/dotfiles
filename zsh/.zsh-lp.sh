# Leadpages shell config

export PATH="/opt/homebrew/bin:${PATH}"

export LDFLAGS="-L$(brew --prefix zlib)/lib -L$(brew --prefix openssl@1.1)/lib -L$(brew --prefix libffi)/lib -L$(brew --prefix xz)/lib -L$(brew --prefix libjpeg)/lib ${LDFLAGS}"
export CPPFLAGS="-I$(brew --prefix zlib)/include -I$(brew --prefix openssl@1.1)/include -I$(brew --prefix bzip2)/include -I$(brew --prefix libffi)/include -I$(brew --prefix libjpeg)/include ${CPPFLAGS}"
export CFLAGS="-I$(brew --prefix zlib)/include -I$(brew --prefix openssl@1.1)/include -I$(brew --prefix bzip2)/include -I$(brew --prefix libffi)/include -I$(brew --prefix xz)/include ${CFLAGS}"

export LIBRARY_PATH="$(brew --prefix)/lib"
export CPATH="$(brew --prefix)/include"

# For compiling python libraries
export LIBMEMCACHED=$(brew --prefix libmemcached)
export GRPC_PYTHON_BUILD_SYSTEM_OPENSSL=1
export GRPC_PYTHON_BUILD_SYSTEM_ZLIB=1

# Its really important to keep the architecture of your shell in mind
# PROMPT="$(arch) ${PROMPT}"

eval "$(brew shellenv)"

# google-cloud-sdk (homebrew)
source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# Python/pyenv (homebrew)
export PATH="/usr/local/opt/python/libexec/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
export PATH="${HOME}/.pyenv/shims:${PATH}"
export PATH="/opt/poetry/bin:/opt/poetry2/bin:${PATH}"


# Pip env variables for hydra libraries
export CPPFLAGS="-I/usr/local/include ${CPPFLAGS}"
export LDFLAGS="-L/usr/local/lib ${LDFLAGS}"
