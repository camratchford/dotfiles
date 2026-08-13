# dotfiles

> Various dotfiles and assorted goodies

## Installing

### Requirements

- [GNU Stow](https://www.gnu.org/software/stow/) (`sudo apt install stow`) — used to symlink the packages in `stow/` into `$HOME`.

### Clone

```bash
git clone https://github.com/camratchford/dotfiles ~/dotfiles
```

### Install

```bash
cd ~/dotfiles
./install.sh
```

Dotfiles are organized into [Stow](https://www.gnu.org/software/stow/) packages under `stow/` (one per tool: `bash`, `vim`, `git`, `kitty`, `lnav`, `tmux`, `bin`, `local-lib`, `local-share`, `local-etc`, `misc`). `install.sh` stows each of them into `$HOME`, moving any pre-existing real file/directory it would collide with into `./backup` first. To (re)install a single package by hand:

```bash
stow -d stow -t ~ vim
```

After the initial setup is complete, the scripts below are run (only if `install.sh` is run interactively). Select each item you wish to install/run, and confirm to apply the changes or cancel to continue without making any changes.

- *dotfiles-install-software-packages* - Install collections of packages based on category. The categories are listed in the `software_packages` directory.
- *dotfiles-run-tasks* - Run post-install tasks (like installing packages from PPA repos, configuring ZFS, downloading and installing JetBrains Toolbox). The task scripts are located in the `tasks` directory.

### Restart Shell

```bash
exec bash
```

## Features

In addition to supplying dotfiles, this repo:

- Installs Vim plugins via `git submodule`
- Installs help for any Vim plugins
- Sets up the user crontab with jobs to execute `run-parts` on a local set of the very common `cron.{hourly,daily,weekly,monthly}` directories.
  - Ships with some scripts in `./stow/local-etc/.local/etc/cron.{hourly,daily,weekly,monthly}`
- Defines aliases (`./stow/bash/.bash_aliases`)
- Sources functions (`./stow/local-lib/.local/lib/bash-libs/*`)
- Adds scripts to `PATH` (`./stow/bin/bin/*`, `./.local/bin/*`)
- Sets a Git-aware PS1 prompt `./termprompt.sh`
- Facilities for installing commonly installed Apt packges (`./stow/bin/bin/dotfiles-install-software-packages`)
- Facilities for running commonly executed system customization tasks (`./stow/bin/bin/dotfiles-run-tasks`)

