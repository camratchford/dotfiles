# dotfiles

> Various dotfiles and assorted goodies

## Installing

### Requirements

- [GNU Stow](https://www.gnu.org/software/stow/) (`sudo apt install stow`) — used to symlink the packages in `stow/` into `$HOME`.

### Clone

```bash
git clone https://github.com/camratchford/dotfiles ~/dotfiles
```

> If you already had this repo cloned from before the move to Stow, the vendored Vim/tmux plugins (`.vim/bundle/*`, `.local/share/ansi`, `tmux/plugins/tpm`) are now git submodules at new paths under `stow/`. Run `git submodule sync --recursive && git submodule update --init --recursive` after pulling so your local submodule config picks up the new paths.

### Install

```bash
cd ~/dotfiles
./install.sh
```

Dotfiles are organized into [Stow](https://www.gnu.org/software/stow/) packages under `stow/` (one per tool: `bash`, `vim`, `git`, `kitty`, `lnav`, `tmux`, `bin`, `local-lib`, `local-share`, `local-etc`, `misc`). `install.sh` stows each of them into `$HOME`, moving any pre-existing (real) file/directory into `./backup` first to avoid overwriting anything important.

To (re)install a single package by hand:

```bash
stow -d stow -t ~ vim
```

After the initial setup is complete, the scripts below are run (only if `install.sh` is run interactively). Select each item you wish to install/run, and confirm to apply the changes or cancel to continue without making any changes.

- `dotfiles-install-software-packages` - Install collections of packages based on category. The categories are listed in the `software_packages` directory.
- `dotfiles-run-tasks` - Run post-install tasks (like installing packages from PPA repos, configuring ZFS, downloading and installing JetBrains Toolbox). The task scripts are located in the `tasks` directory.

### Restart Shell

```bash
exec bash
```

## Features

In addition to supplying dotfiles, this repo:

- Installs Vim plugins via `git submodule`
- Installs help for any Vim plugins
- Manages tmux plugins via TPM, also included as a `git submodule`
- Sets up the user crontab with jobs to execute `run-parts` on a local set of the very common `cron.{hourly,daily,weekly,monthly}` directories
  - Ships with some utility scripts in `./stow/local-etc/.local/etc/cron.{hourly,daily,weekly,monthly}`
- Facilities for backing up arbitrary paths via rsync, driven from cron (`./stow/bin/bin/run-backups`)
- Defines aliases (`./stow/bash/.bash_aliases`)
- Sources functions (`./stow/local-lib/.local/lib/bash-libs/*`)
- Adds scripts to `PATH` (`./stow/bin/bin/*`, `./.local/bin/*`)
- Ships bash completions (`./stow/bash/.bash_completions/*`)
- Sets a Git-aware PS1 prompt `./termprompt.sh`
- Includes a user-level `core.excludesFile` (`./stow/git/.config/git/ignore`), that stacks with the project-level `.gitignore` and `.git/info/exclude` files
- Sets the default terminal emulator profile on install
- Facilities for installing commonly installed Apt packges (`./stow/bin/bin/dotfiles-install-software-packages`)
- Facilities for running commonly executed system customization tasks (`./stow/bin/bin/dotfiles-run-tasks`)

