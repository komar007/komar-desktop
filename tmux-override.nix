# This substitutes tmux with a relatively new master that has
# https://github.com/tmux/tmux/issues/4017 fixed
final: prev: {
  tmux = prev.tmux.overrideAttrs (old: {
    # Try below reverts to fix scrollback issues on 3.4 if master is too cutting edge
    #patches = old.patches ++ [
    #  (prev.fetchpatch
    #    {
    #      url = "https://github.com/tmux/tmux/commit/4c928dce746d64456bd7bedb8b909279a1bef3ec.patch";
    #      sha256 = "sha256-+MZuqY+IUibwMFtzmuqAikJe92cHeCKcYoa36FawGII=";
    #    })
    #  (prev.fetchpatch
    #    {
    #      url = "https://github.com/tmux/tmux/commit/5b5004e5ac95b858ef2e134c9e056dd05a38d430.patch";
    #      sha256 = "sha256-n7nIVSo5T/gVvZmQ8JUaQm6WVrBuQaKAxxj/rqTzbZY=";
    #    })
    #];
    patches = [ ];
    src = prev.fetchFromGitHub {
      owner = "tmux";
      repo = "tmux";
      rev = "34807388b064ed922293f128324b7d5d96f0c84d"; # master @ 27.08.2024
      hash = "sha256-zG3oRaahQCOVGTWfWwhDff5/iNbbWbxwIX/clK3vEPM=";
    };
  });
}
