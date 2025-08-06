# dotfiles

> Various dotfiles and assorted goodies

## Installing

Clone and install:

```bash
git clone https://github.com/camratchford/dotfiles ~/dotfiles
cd ~/dotfiles
./install.sh
```

(Optional) Install the suggested Apt and Snap packages:

```bash
# To list what you're installing
sudo ./setup/install_packages.sh --list

# For more options
sudo ./setup_install_packages.sh --help

sudo ./setup/install_packages.sh
```

Apply changes:

```bash
souce ~/.bashrc
```


## Contents

### Dirs
- `.git-templates`
  - What git copies into every new git repo's `.git` directory, the only custom component here is the `.git-templates/info/exclude` file which contains a list of stuff that should definetly not be included in a git commit.
- `.local/lib/bash-libs`
  - A collection of useful bash functions, sorted by category into separate files.
- `.local/share/cron.d`
  - A set of directories configured by the `install.sh` script to have their contents executed periodically by `run-parts`.
  - Same idea as `/etc/cron.{daily,hourly,weekly,yearly}`, including monthly rather than yearly.
  - `.local/share/cron.d/{daily,hourly,monthly,weekly}`
- `.local/share/logrotate`
  - Contains `logrotate.conf`
    - The configuration file for the `.local/share/cron.d/daily/logrotate.sh` script that is executed daily
    - Makes a backup of `~/.history`
- `.vim`
  - Contains submodules for vim plugins
- `setup`
  - A setup script to install Apt and Snap packages.
  - Run `sudo ./setup/install_pacakges.sh --help` for more info
- `tmux`
  - Contains submodules ofr tmux plugins


### Files

- `.bashrc`
  - Appends several directories to PATH
    - `~/bin`
    - `~/.local/bin`
    - `~/.local/share/ansi/bin`
  - dot-sources several files
    - `~/.bash_completions`
    - `~/.local/share/bash-completion`
    - `~/.bash_aliases`
    - `~/.bashrc.local` if it exists
    - `~/.local/lib/bash-libs/*`
    - `~/dotfiles/termprompt.sh`
- `.bash_aliases`
  - Sets aliases and env vars (like `PAGER` and `EDITOR`)
- `.gitconfig`
  - Default git config settings
  - Includes `.gitconfig.work` if it exists.
- `.inputrc`
  - Default bash settings and hotkey mappings
- `.lscolors`
  - Color per file format for ls/exa/eza
- `.tmux.conf`
  - Default tmux settings
- `.vimrc`
  - Default vim settings
- `install.sh`
  - Backups up the files it would overwrite, placing it in `backups`, then archiving it with the day's date.
  - Symlinks the dotfiles and dotdirs
  - Generates cron jobs for the new directories `.local/share/cron.d/{daily,hourly,monthly,weekly}`
  - Runs `git submodule init && git submodule update`
  - Generates vim help documents for vim plugins imported via git submodules
  - Creates an `uninstall.sh` script to put everything back how it was found
- `termprompt.sh`
  - Sets the `PS1` and `PROMPT_COMMAND` variables, similar to gitstatus

