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

MISE_CONFIG_DIR="$repo/home/.config/mise" \
MISE_DOTFILES_ROOT="$repo/home" \
"$mise_bin" bootstrap --yes --force-dotfiles --skip task
