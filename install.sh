#!/bin/bash -i

THIS_DIR="$(dirname "$(realpath "$0")")"

STOW_DIR="$THIS_DIR/stow"
BACKUP_DIR="$THIS_DIR/backup"
mkdir -p "$BACKUP_DIR"

if ! command -v stow &> /dev/null; then
  echo "GNU Stow is required but not installed. Install it with 'sudo apt install stow'." >&2
  exit 1
fi

STOW_PACKAGES=(
  bash
  vim
  git
  kitty
  lnav
  tmux
  bin
  local-lib
  local-share
  local-etc
  misc
)

# Stow refuses to link over anything it doesn't already own. Move real files/dirs
# out of the way into $BACKUP_DIR, and drop any stale (e.g. pre-stow) symlinks,
# then let stow do the linking.
function stow-package {
  local package="$1"
  local relative_path

  while IFS= read -r relative_path; do
    [ -z "$relative_path" ] && continue
    local target="$HOME/$relative_path"
    if [ -L "$target" ]; then
      rm "$target"
    elif [ -e "$target" ]; then
      mkdir -p "$BACKUP_DIR/$(dirname "$relative_path")"
      mv "$target" "$BACKUP_DIR/$relative_path"
    fi
  done < <(stow -n -d "$STOW_DIR" -t "$HOME" "$package" 2>&1 | sed -n \
    -e 's/^  \* existing target is not owned by stow: //p' \
    -e 's/^  \* cannot stow .* over existing target \(.*\) since neither a link nor a directory and --adopt not specified/\1/p')

  stow -d "$STOW_DIR" -t "$HOME" "$package"
}

for package in "${STOW_PACKAGES[@]}"; do
  stow-package "$package"
done

# Create user cron directories similar to /etc/cron.${period} directories
CRON_PARENT_DIR=".local/etc"
mkdir -p "$HOME/$CRON_PARENT_DIR/cron.d"
readarray CRONTAB_CONTENTS <<< "$(crontab -l 2>/dev/null)"
for period in hourly daily weekly monthly; do
  PERIOD_DIR="$HOME/$CRON_PARENT_DIR/cron.$period"

  # Execute the contents of `$HOME/.local/etc/cron.$period` every `$period`
  CRON_JOB="@$period run-parts --verbose $PERIOD_DIR"

  if ! [[ ${CRONTAB_CONTENTS[*]} =~ $CRON_JOB ]]; then
    CRONTAB_CONTENTS+=("$CRON_JOB")
  fi
done

CRONTAB_ENV=(
  "BASH_ENV=$HOME/.bash_env"
)
# Make sure each variable is prepended to the crontab
for env_item in "${CRONTAB_ENV[@]}"; do
  if ! crontab -l 2> /dev/null | grep -q "$env_item"; then
    CRONTAB_CONTENTS=("$env_item" "${CRONTAB_CONTENTS[@]}")
  fi
done

# Finally, write the crontab
(printf "%s\n" "${CRONTAB_CONTENTS[@]}") | crontab -

# Make sure my Konsole profile is set as default
if which konsole &> /dev/null; then
  kwriteconfig5 --file konsolerc --group "Desktop Entry" --key DefaultProfile "Custom.profile"
fi

# Install Pathogen, a Vim plugin manager
mkdir -p ~/.vim/autoload ~/.vim/bundle
if ! [ -f ~/.vim/autoload/pathogen.vim ]; then
  curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
fi

# Add Vim plugins
git submodule init
git submodule update --init --recursive --depth 1

# Install Vim plugin docs
DOCS_DIRS="$(find ~/.vim/bundle -path "*/doc")"
for docdir in $DOCS_DIRS; do
  vim -es -u NONE -c "helptags $docdir" -c "q"
done


# Exit if not being run interactively
case $- in
    *i*) ;;
      *) return;;
esac

sudo "$THIS_DIR/stow/bin/bin/dotfiles-install-software-packages"
"$THIS_DIR/stow/bin/bin/dotfiles-run-tasks"
