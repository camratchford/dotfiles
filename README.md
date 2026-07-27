# dotfiles

> Various dotfiles and assorted goodies

## Installing

### Clone

```bash
git clone https://github.com/camratchford/dotfiles ~/dotfiles
```

### Install

```bash
cd ~/dotfiles
./install.sh
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
  - Ships with some scripts in the `./.local/etc/cron.{houry,daily,weekly,monthly}`
- Defines aliases (`./.bash_aliases`)
- Sources functions (`./.local/lib/bash-libs/*`)
- Adds scripts to `PATH` (`./bin/*`, `./.local/bin/*`)
- Sets a Git-aware PS1 prompt `./termprompt.sh`
- Facilities for installing commonly installed Apt packges (`./bin/dotfiles-install-software-packages`)
- Facilities for running commonly executed system customization tasks (`./bin/dotfiles/run-tasks`)

