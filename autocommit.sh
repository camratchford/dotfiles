#!/bin/bash
THIS_DIR="$(dirname $(realpath $0))"
DEFAULT_BRANCH="$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')"
cd $THIS_DIR
git add .
git commit -m "Autocommit $(date)"
git push -f origin "$DEFAULT_BRANCH"



