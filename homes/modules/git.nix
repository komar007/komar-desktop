{ lib, pkgs, ... }: {
  programs.git.enable = true;
  programs.git.aliases = {
    uncommit = "!git reset --soft HEAD^ && git reset";
    wip = "commit -a -m wip";
    unwip = "!${pkgs.writeShellScript "git-unwip" ''
      if [ "$(git log -1 --pretty=format:%B | head -n 1)" = wip ]; then
        git uncommit
      else
        echo NOT A WIP 2>/dev/stderr
        exit 1
      fi
    ''}";
    pg = "!${pkgs.writeShellScript "git-pg" ''
      set -e
      if [ -n "$(git status --porcelain 2>/dev/null | egrep '^(M| M)')" ]; then
        echo 'refusing to push, dirty dir'
        exit 1
      fi

      PREV=$(git rev-parse --abbrev-ref HEAD)
      PUSH_BRANCH=push_branch
      MAIN_BRANCH=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')
      PUSH_TO="HEAD:refs/for/$MAIN_BRANCH"

      git checkout "$MAIN_BRANCH" -b "$PUSH_BRANCH"

      FAILED=0
      if ! git cherry-pick "$1"; then
        echo "fix conflicts and exit shell"
        git status
        PS1_EXTRA="CP FAILED" $SHELL
        git cherry-pick --continue || FAILED=1
      fi

      if [ "$FAILED" -eq 0 ]; then
        if git push origin "$PUSH_TO"; then
          echo "successfully pushed $1"
        else
          echo "failed to push, backup changes or push yourself to $PUSH_TO and exit shell"
          PS1_EXTRA="PUSH FAILED" $SHELL
        fi
      else
        echo "cherry-pick --continue failed, backup changes or push yourself to $PUSH_TO and exit shell"
        PS1_EXTRA="CP CONT FAILED" $SHELL
        git cherry-pick --abort || true
      fi
      git checkout $PREV
      git branch -D "$PUSH_BRANCH"
    ''}";
    as = "!git rebase -i --autosquash $(git log --format='%H' HEAD^ | grep -m 1 --color=never -F $(git branch --format='-e %(objectname)'))";
    newdate = "commit --amend --no-edit --date=now";
  };
  programs.git.includes = [
    { path = "~/.gitconfig.local"; }
  ];
  programs.git.extraConfig = {
    color = {
      ui = "auto";
    };
    core = {
      whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";
      autocrlf = false;
      pager = "less -FRX";

    };
    http = {
      cookiefile = "~/.gitcookies";
    };
    push = {
      default = "matching";
    };
  };
}
