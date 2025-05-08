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
    pg = "!${lib.getExe (pkgs.writeShellApplication {
      name = "git-pg";
      runtimeInputs = [ pkgs.cowsay ];
      text = builtins.readFile ./pg.sh;
    })}";
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
