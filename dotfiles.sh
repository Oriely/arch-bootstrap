#!/usr/bin/env sh

REPO=https://github.com/Oriely/dotfiles.git
DOTFILES="$HOME/.dotfiles"

dotcfg () {
  git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" "$@"
}

git clone --bare $REPO $DOTFILES
dotcfg config --local status.showUntrackedFiles no
dotcfg checkout -f