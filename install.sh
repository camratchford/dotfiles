#!/bin/bash -i

THIS_DIR="$(dirname "$(realpath "$0")")"
UNINSTALL_SCRIPT="$THIS_DIR/uninstall.sh"

echo '#!/bin/bash' > "$UNINSTALL_SCRIPT"
chmod 755 "$UNINSTALL_SCRIPT"
BACKUP_DIR="$THIS_DIR/backup"

if [ -d "$BACKUP_DIR" ] && ! [ "$(ls -A "$BACKUP_DIR")" ]; then
  now="$(date +%Y_%m_%d+%H-%M-%S)"
  archive_name="dotfiles-backup-$now.tar.gz"
  cd "$BACKUP_DIR" && tar cz ./ > "../$archive_name"
fi
mkdir -p "$BACKUP_DIR"

function link-dir {
  local src="$1"
  local target="$2"

  if [ -d "$target/$(basename "$src")" ] && ! [ -L "$target/$(basename "$src")" ] ;then
    mv "$target/$(basename "$src")" "$BACKUP_DIR/$(basename "$src")"
  fi

  mkdir -p "$target"

  ln -s "$src" "$target/" 2> /dev/null
  echo "rm -f $target/$(basename "$src")" >> "$UNINSTALL_SCRIPT"
}

# Deal with sym-linking files
DOTFILES=$(find "$THIS_DIR" -maxdepth 1 -type f -name ".*" -not -name "*.gitmodules" -not -name "*.gitignore")
for file in $DOTFILES; do
  home_name="$HOME/$(basename "$file")"
  if [ -f "$home_name" ] && ! [ -L "$home_name"  ]; then
    mv "$home_name" "$BACKUP_DIR"
  elif [ -L "$home_name" ]; then
    rm "$home_name"
  fi
  ln -s "$file" "$home_name"
  echo "rm -f $home_name" >> "$UNINSTALL_SCRIPT"
done

# Specify the exact location of the dotdirs
SYMLINK_DIRS=(
  "$THIS_DIR/.vim:$HOME"
  "$THIS_DIR/.config/lnav/configs:$HOME/.config/lnav"
)
for src_target in "${SYMLINK_DIRS[@]}"; do
  IFS=":" read -r src target <<< "$src_target"
  link-dir "$src" "$target"
done

# Symlink dirs 'dotfiles/.local/*' to '$HOME/.local/'
readarray -d '' CONTENTS_OF_DOT_LOCAL <<< find "$THIS_DIR/.local" -mindepth 1 -maxdepth 1 -type d -print0
for dir in "${CONTENTS_OF_DOT_LOCAL[@]}"; do
  readarray -d '' DOT_LOCAL_SUBDIRS <<< find "$dir" -mindepth 1 -maxdepth 1 -type d -print0
  for src in "${DOT_LOCAL_SUBDIRS[@]}"; do
    link-dir "$src" "$HOME/.local/$(basename "$dir")"
  done
done

# Create user cron directories similar to /etc/cron.${period} directories
readarray CRONTAB_CONTENTS <<< "$(crontab -l 2>/dev/null)"
CRON_PARENT_DIR=".local/etc"
mkdir -p "$HOME/$CRON_PARENT_DIR/cron.d"
for period in hourly daily weekly monthly; do
  PERIOD_DIR="$CRON_PARENT_DIR/cron.$period"
  link-dir "$THIS_DIR/$CRON_PARENT_DIR/cron.$period" "$HOME/$CRON_PARENT_DIR"

  # Execute the contents of `$HOME/.local/etc/cron.$period` every `$period`
  CRON_JOB="@$period run-parts $PERIOD_DIR"

  if ! [[ ${CRONTAB_CONTENTS[*]} =~ $CRON_JOB ]]; then
    CRONTAB_CONTENTS+=("$CRON_JOB")
  fi

  # Allow undoing
  CLEAN_CRON_JOB=$(printf %s "$CRON_JOB" | sed 's:/:\\/:g')
  sed_cmd="/${CLEAN_CRON_JOB}/d"
  echo "crontab -l 2> /dev/null | sed -e '$sed_cmd' | crontab -" >> "$UNINSTALL_SCRIPT"
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

# Install my Vim plugin manager
mkdir -p ~/.vim/autoload ~/.vim/bundle
if ! [ -f ~/.vim/autoload/pathogen.vim ]; then
  curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
  echo "rm ~/.vim/autoload/pathogen.vim" >> "$UNINSTALL_SCRIPT"
fi

# Add Vim plugins
git submodule init
git submodule update --init --recursive --depth 1
# shellcheck disable=SC2016
git submodule foreach 'echo rm -rf $sm_path >> $toplevel/uninstall.sh > /dev/null' > /dev/null

# Install Vim plugin docs
DOCS_DIRS="$(find ~/.vim/bundle -path "*/doc")"
for docdir in $DOCS_DIRS; do
  vim -es -u NONE -c "helptags $docdir" -c "q"
done

