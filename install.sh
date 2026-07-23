#!/bin/sh
set -eu

repo=$HOME/.local/share/etc
if [ "$(CDPATH= cd -- "$(dirname "$0")" && pwd)" != "$repo" ]; then
    printf '%s\n' "etc must be checked out at $repo" >&2
    exit 1
fi

mkdir -p "$HOME/.local/bin"

mise_bin=$HOME/.local/bin/mise
if [ ! -x "$mise_bin" ]; then
    curl -fsSL https://mise.run |
        env MISE_INSTALL_PATH="$mise_bin" sh
fi

PATH="$HOME/.local/bin:$PATH"
export PATH

lock_target=$HOME/.config/mise/mise.lock
lock_source=$repo/home/.config/mise/mise.lock
mkdir -p "$(dirname "$lock_target")"
if [ ! -e "$lock_target" ] && [ ! -L "$lock_target" ]; then
    ln -s "$lock_source" "$lock_target"
fi

MISE_CONFIG_DIR="$repo/home/.config/mise" \
MISE_DOTFILES_ROOT="$repo/home" \
"$mise_bin" bootstrap --yes --force-dotfiles --skip task
