{ lib, config, pkgs, ... }:

let
  hibernateEnvironment = {
    HIBERNATE_SECONDS = toString config.hibernate-while-in-suspend.seconds;
    AC_ONLINE_FILE = toString config.hibernate-while-in-suspend.ac-online-file;
    HIBERNATE_LOCK = "/var/run/autohibernate.lock";
    HIBERNATE_LOG = "/tmp/autohibernate.log";
  };
in {
  options.hibernate-while-in-suspend.seconds = lib.mkOption {
    type = lib.types.int;
  };
  options.hibernate-while-in-suspend.ac-online-file = lib.mkOption {
    type = lib.types.str;
  };

  # https://gist.github.com/mattdenner/befcf099f5cfcc06ea04dcdd4969a221

  config.systemd.services."awake-after-suspend-for-a-time" = {
    description = "Sets up the suspend so that it'll wake for hibernation only if not on AC power";
    wantedBy = [ "suspend.target" ];
    before = [ "systemd-suspend.service" ];
    environment = hibernateEnvironment;
    script = ''
      if [ $(cat $AC_ONLINE_FILE) -eq 0 ]; then
        curtime=$(date +%s)
        echo "$curtime $1" >> $HIBERNATE_LOG
        echo "$curtime" > $HIBERNATE_LOCK
        ${pkgs.utillinux}/bin/rtcwake -m no -s $HIBERNATE_SECONDS
      else
        echo "System is on AC power, skipping wake-up scheduling for hibernation." >> $HIBERNATE_LOG
      fi
    '';
    serviceConfig.Type = "simple";
  };

  config.systemd.services."hibernate-after-recovery" = {
    description = "Hibernates after a suspend recovery due to timeout";
    wantedBy = [ "suspend.target" ];
    after = [ "systemd-suspend.service" ];
    environment = hibernateEnvironment;
    script = ''
      curtime=$(date +%s)
      sustime=$(cat $HIBERNATE_LOCK)
      rm $HIBERNATE_LOCK
      if [ $(($curtime - $sustime)) -ge $HIBERNATE_SECONDS ] ; then
        systemctl hibernate
      else
        ${pkgs.utillinux}/bin/rtcwake -m no -s 1
      fi
    '';
    serviceConfig.Type = "simple";
  };
}
