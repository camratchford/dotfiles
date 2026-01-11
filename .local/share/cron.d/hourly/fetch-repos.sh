
git -C ~/dotfiles/ fetch --quiet origin &
for project_dir in /projects/*/; do
  if [ $(git -C $project_dir rev-parse && /bin/true) ]; then
    continue
  fi
  git -C $project_dir fetch -q origin &
done
