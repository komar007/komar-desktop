#!/bin/sh

set -e

pg_msg() {
  tput setaf "${COLOR:-4}"
  echo "$@" | cowsay -W 79 2> /dev/null
  tput sgr0
}

if git status --porcelain 2>/dev/null | grep -qE '^(M| M)'; then
  COLOR=1 pg_msg 'refusing to push, dirty dir'
  exit 1
fi

PREV=$(git rev-parse --abbrev-ref HEAD)
PUSH_BRANCH=push_branch
MAIN_BRANCH=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')
PUSH_TO="HEAD:refs/for/$MAIN_BRANCH"

temp_shell() {
  if ! $SHELL; then
    pg_msg 'shell exit with error, type "continue" to continue pg instead of interrupting'
    read -r c
    if [ "$c" = "continue" ]; then
      return 0
    else
      return 1
    fi
  fi
}

git checkout "$MAIN_BRANCH" -b "$PUSH_BRANCH"

FAILED=0
if ! git cherry-pick "$1"; then
  git status
  pg_msg "fix conflicts and exit shell"
  PS1_EXTRA="CP FAILED" temp_shell
  git cherry-pick --continue || FAILED=1
fi

if [ "$FAILED" -eq 0 ]; then
  if git push origin "$PUSH_TO"; then
    COLOR=2 pg_msg "successfully pushed $1"
  else
    COLOR=1 pg_msg "failed to push, backup changes or push yourself to $PUSH_TO and exit shell"
    PS1_EXTRA="PUSH FAILED" temp_shell
  fi
else
  COLOR=1 pg_msg "cherry-pick --continue failed, backup changes or push yourself to $PUSH_TO and exit shell"
  PS1_EXTRA="CP CONT FAILED" temp_shell
  git cherry-pick --abort || true
fi
git checkout "$PREV"
git branch -D "$PUSH_BRANCH"
