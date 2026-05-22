
git -C ~/dotfiles/ fetch --quiet origin &
for project_dir in /projects/*/; do
  if [ "$(git -C "$project_dir" rev-parse --show-toplevel 2> /dev/null)" != "$project_dir" ]; then
    continue
  fi
  git -C $project_dir fetch -q origin &
done
