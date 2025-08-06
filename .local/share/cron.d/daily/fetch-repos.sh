for d in ~/work/*/; do
  git -C $d fetch --quiet origin &
done
