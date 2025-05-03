{ config, pkgs, nixpkgs-unstable, ...}: {
  systemd.services.regulate-brightness = {
    description = "adjust screen brightness based on illuminance";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      Restart = "always";
    };
    script = (builtins.readFile ./regulate-script.sh);
  };
}
