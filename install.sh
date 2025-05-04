#!/bin/bash -i

THISDIR="$(dirname $(realpath $0))"
UNINSTALL_SCRIPT="$THISDIR/uninstall.sh"


touch $UNINSTALL_SCRIPT
echo '#!'"/bin/bash" > $UNINSTALL_SCRIPT
chmod +x $UNINSTALL_SCRIPT
BACKUP_DIR="$THISDIR/backup"
mkdir -p $BACKUP_DIR

function link-dir {
  local src="$1"
  local target="$2"
  if ! [ -d "$target" ]; then
    mkdir -p "$(dirname $target)"
    mkdir -p "$target"
  fi
  ln -fs "$src" "$target" 2> /dev/null
  echo "rm -f $target$(basename $src)" >> $UNINSTALL_SCRIPT
}

# Deal with symlinking files
DOTFILES=$(find $THISDIR -maxdepth 1 -type f -name ".*" -not -name "*.gitmodules" -not -name "*.gitignore")
for file in $DOTFILES; do
  home_name="$HOME/$(basename $file)"
  if [ -f $home_name ]; then
    mv $home_name $BACKUP_DIR
  fi
  ln -fs "$file" $home_name
  echo "rm -f $home_name" >> $UNINSTALL_SCRIPT
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
for dir in $(find $THISDIR/.local -maxdepth 1 -type d -not -wholename "$THISDIR/.local"); do
  for src in $(find $dir -maxdepth 1 -type d -not -wholename "$dir"); do
    link-dir "$src" "$HOME/.local/$(basename $dir)/"
  done
done


# User cron directories similar to /etc/cron.${period} directories
for period in hourly daily weekly monthly; do
  cron_dir="$HOME/.local/share/cron.d/"
  cron_file="$THISDIR/cronfile"
  if ! [ -d $cron_dir ]; then
    mkdir -p $cron_dir
  fi
  echo "@$period run-parts $HOME/.local/share/cron.d/$period" >> "$cron_file"

  crontab -l 2>/dev/null | cat - "$cron_file" | crontab -
  echo 'crontab -l 2> /dev/null | '"sed -e \"/@$period run-parts ${HOME//\//\\/}\/.local\/share\/cron.d\/$period/d\" | crontab -" >> $UNINSTALL_SCRIPT
  rm "$cron_file"
done
ln -fs /var/spool/cron/crontabs/$USER $HOME/.local/share/cron.d/crontab


# Vim plugin manager
mkdir -p ~/.vim/autoload ~/.vim/bundle
if ! [ -f ~/.vim/autoload/pathogen.vim ]; then
  curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
  echo "rm ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim" >> $UNINSTALL_SCRIPT
fi

git submodule init
git submodule update --init --recursive --depth 1
git submodule foreach 'echo rm -rf $sm_path >> $toplevel/uninstall.sh > /dev/null' > /dev/null

# Install vim plugin docs
DOCDIRS="$(find ~/.vim/bundle -path "*/doc")"

for docdir in $DOCDIRS; do
  exec vim -c "helptags $docdir" -c quit
done

