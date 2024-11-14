#!/bin/bash
THIS_DIR="$(dirname $(realpath $0))"

cd $THIS_DIR
git add .
git commit -m "Autocommit $(date)"
git push -f origin main



