#!/bin/bash -i

THISDIR="$(dirname $(realpath $0))"

function link-dir {
    local src="$1"
    local target="$2"
    mkdir -p "$(dirname "$(realpath "$target")")"
    ln -fs "$src" "$target" 2> /dev/null
}

SYMLINK_DIRS=(
  "$THISDIR/bin:$HOME/"
  "$THISDIR/.vim:$HOME/"
  "$THISDIR/bash-libs:$HOME/.local/lib/"
  "$THISDIR/cron.d:$HOME/.local/share/"
  "$THISDIR/.git-templates:$HOME/.git-templates"
)

# Deal with symlinking files
DOTFILES=$(find $THISDIR -maxdepth 1 -type f -name ".*" -not -name "*.gitmodules" -not -name "*.gitignore")
for file in $DOTFILES; do
  file_name=$(echo "$file" | sed "s|^$THISDIR/||")
  ln -fs "$file" "$HOME/$file_name"
done

for src_target in "${SYMLINK_DIRS[@]}"; do
  IFS=":" read -r src target <<< "$src_target"
  link-dir "$src" "$target"
done

for period in hourly daily weekly monthly; do
  cron_file="$HOME/.local/share/cron.d/$period.cron"
  mkdir -p "$(dirname "$cron_file")"  # Ensure the cron.d directory exists

  # Add the cron job for the period
  echo "@$period run-parts $HOME/.local/share/cron.d/$period" >> "$cron_file"

  # Append to the current crontab (not overwrite)
  crontab -l 2>/dev/null | cat - "$cron_file" | crontab -

  # Clean up the temporary cron file
  rm "$cron_file"
done

mkdir -p ~/.vim/autoload ~/.vim/bundle
if ! [ -f ~/.vim/autoload/pathogen.vim ]; then
  curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
fi

git submodule init
git submodule update

# Install vim plugin docs

DOCDIRS="$(find ~/.vim/bundle -path "*/doc")"

for docdir in $DOCDIRS; do
  exec vim -c "helptags $docdir" -c quit
done

