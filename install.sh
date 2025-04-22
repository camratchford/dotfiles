#!/bin/bash -i

THISDIR="$(dirname $(realpath $0))"

function link-dir {
    local src="$1"
    local target="$2"
    mkdir -p "$(dirname "$(realpath "$target")")"
    ln -fs "$src" "$target" 2> /dev/null
}

SYMLINK_DIRS=("$THISDIR/bin:$HOME/" "$THISDIR/.vim:$HOME/" "$THISDIR/.local/lib/bash-libs:$HOME/.local/lib/")

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

mkdir -p ~/.vim/autoload ~/.vim/bundle
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
git submodule init
git submodule update

