#!/bin/bash -i

THISDIR="$(dirname "$(realpath "$0")")"
UNINSTALL_SCRIPT="$THISDIR/uninstall.sh"

echo '#!/bin/bash' > "$UNINSTALL_SCRIPT"
chmod 755 "$UNINSTALL_SCRIPT"
BACKUP_DIR="$THISDIR/backup"

if [ -d "$BACKUP_DIR" ] && ! [ "$(ls -A "$BACKUP_DIR")" ]; then
  now="$(date +%Y_%m_%d+%H-%M-%S)"
  archive_name="dotfiles-backup-$now.tar.gz"
  cd "$BACKUP_DIR" && tar cz ./ > "../$archive_name"
fi
mkdir -p "$BACKUP_DIR"

function link-dir {
  local src="$1"
  local target="$2"

  if [ -d "$target$(basename "$src")" ] && ! [ -L "$target$(basename "$src")" ] ;then
    mv "$target$(basename "$src")" "$BACKUP_DIR/$(basename "$src")"
  fi

  mkdir -p "$(dirname "$target")"
  mkdir -p "$target"

  ln -s "$src" "$target" 2> /dev/null
  echo "rm -f $target$(basename "$src")" >> "$UNINSTALL_SCRIPT"
}

# Deal with symlinking files
DOTFILES=$(find "$THISDIR" -maxdepth 1 -type f -name ".*" -not -name "*.gitmodules" -not -name "*.gitignore")
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
  "$THISDIR/.git-templates:$HOME/"
  "$THISDIR/bin:$HOME/"
  "$THISDIR/.vim:$HOME/"
)
for src_target in "${SYMLINK_DIRS[@]}"; do
  IFS=":" read -r src target <<< "$src_target"
  link-dir "$src" "$target"
done

# Symlink dirs 'dotfiles/.local/*' to '$HOME/.local/'
readarray -d '' CONTENTS_OF_DOT_LOCAL < <(find "$THISDIR/.local" -mindepth 1 -maxdepth 1 -type d -print0)
for dir in "${CONTENTS_OF_DOT_LOCAL[@]}"; do
  readarray -d '' DOT_LOCAL_SUBDIRS < <(find "$dir" -mindepth 1 -maxdepth 1 -type d -print0)
  for src in "${DOT_LOCAL_SUBDIRS[@]}"; do
    link-dir "$src" "$HOME/.local/$(basename "$dir")/"
  done
done

# Create user cron directories similar to /etc/cron.${period} directories
for period in hourly daily weekly monthly; do
  cron_dir="$HOME/.local/share/cron.d/"
  cron_file="$THISDIR/cronfile"
  if ! [ -d "$cron_dir" ]; then
    mkdir -p "$cron_dir"
  fi
  # Execute the contents of `$HOME/.local/share/cron.d/$period` every `$period`
  echo "@$period run-parts $HOME/.local/share/cron.d/$period" >> "$cron_file"
  crontab -l 2>/dev/null | cat - "$cron_file" | crontab -

  # Allow undoing
  escaped_home=$(printf %s "$HOME" | sed 's:/:\\/:g')
  sed_cmd="/@${period} run-parts ${escaped_home}\/.local\/share\/cron.d\/${period}/d"
  echo "crontab -l 2>/dev/null | sed -e '$sed_cmd' | crontab -" >> "$UNINSTALL_SCRIPT"
  rm "$cron_file"
done

# Symlink the current user's crontab to the local cron.d dir
ln -fs "/var/spool/cron/crontabs/$USER" "$HOME/.local/share/cron.d/crontab"

# Vim plugin manager
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
DOCDIRS="$(find ~/.vim/bundle -path "*/doc")"
for docdir in $DOCDIRS; do
  vim -es -u NONE -c "helptags $docdir" -c "q"
done

