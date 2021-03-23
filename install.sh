#!/usr/bin/env bash

set -u

BASEDIR=$(dirname $0)
cd $BASEDIR

for f in .??*; do
    [[ "$f" == ".git" ]] && continue
    [[ "$f" == ".DS_Store" ]] && continue

    ln -snfv ${PWD}/"$f" ~
done
