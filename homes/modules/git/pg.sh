#!/bin/sh

# Push a single commit to gerrit by cherry-picking it on top of the main branch and pushing.
#
# Features:
# - dirty work dir prevention,
# - interactive conflict fixing if the commit doesn't apply cleanly,
# - a chance to backup result of conflict fixing if it still doesn't apply,
# - immediate exit without making changes when interactive shell is exited with error.

set -e

pg_msg() {
  case "${COLOR:-blue}" in
    green)
      seed=63
      ;;
    red)
      seed=73
      ;;
    blue)
      seed=100
      ;;
  esac
  if [ -n "${seed:-}" ]; then
    colorize="lolcat -S $seed -p 10"
  else
    colorize="cat"
  fi
  echo "$@" | cowsay -W 79 | $colorize 2> /dev/null
}

if git status --porcelain 2>/dev/null | grep -qE '^(M| M)'; then
  COLOR=red pg_msg 'refusing to push, dirty dir'
  exit 1
fi

PREV=$(git rev-parse --abbrev-ref HEAD)
PUSH_BRANCH=push_branch
MAIN_BRANCH=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')
PUSH_TO="HEAD:refs/for/$MAIN_BRANCH"

temp_shell() {
  if ! $SHELL; then
    COLOR=red pg_msg 'shell exit with error, about to interrupt pg, type "continue" to continue pg instead of interrupting'
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
    COLOR=green pg_msg "successfully pushed $1"
  else
    COLOR=red pg_msg "failed to push, backup changes or push yourself to $PUSH_TO and exit shell"
    PS1_EXTRA="PUSH FAILED" temp_shell
  fi
else
  COLOR=red pg_msg "cherry-pick --continue failed, backup changes or push yourself to $PUSH_TO and exit shell"
  PS1_EXTRA="CP CONT FAILED" temp_shell
  git cherry-pick --abort || true
fi
git checkout "$PREV"
git branch -D "$PUSH_BRANCH"
