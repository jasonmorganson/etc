# etc

Portable, user-scoped workstation foundations bootstrapped with
[`mise`](https://mise.jdx.dev/).

The repository installs a low-precedence `00-etc.toml` fragment under
`~/.config/mise/conf.d`. User dotfiles can add higher-precedence global
configuration without copying this core.

## Setup

Clone to the canonical checkout and run the installer:

```sh
git clone https://github.com/jasonmorganson/etc.git ~/.local/share/etc
~/.local/share/etc/install.sh
```

Everything is installed below `$HOME`. The installer does not use `sudo` or
write to `/etc`.

The repository lockfile remains source-local and is used by the installer.
Higher-precedence user dotfiles can install their own merged global lockfile
without competing with the core for the same target.

## Includes

- XDG config, cache, data, state, and user-bin paths
- Rootless Zsh, Fish, and Nushell tool installs
- Mise activation for Bash, Zsh, Fish, and Nushell

Personal Git identity, SSH configuration, application preferences, aliases,
themes, and employer-specific tools belong in a higher-precedence user config.

## Updating

Pull or check out the desired revision, then rerun:

```sh
~/.local/share/etc/install.sh
```
