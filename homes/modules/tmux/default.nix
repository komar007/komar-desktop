{ lib, pkgs, tmux-module, tmux-alacritty-module, ... }: {
  imports = [
    tmux-module
    tmux-alacritty-module
  ];

  home.file.".session_dir.sh".source = ./session_dir.sh;

  # TODO: perhaps generate .shell.sh and .session_dir.sh from simple nix options (mapping between
  # session name and (dir, shell)
}
