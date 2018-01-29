{ config, lib, pkgs, ... }:

with lib;

{
  # Logs are enabled by default.
  # $ tail -f /var/log/ofborg.log
  services.ofborg.enable = true;
  services.ofborg.package = (import <ofborg> {}).ofborg.rs;
  # services.ofborg.configFile = "/var/lib/ofborg/config.json";

  services.nix-daemon.enable = true;

  nix.package = pkgs.nixUnstable;

  nix.gc.automatic = true;
  nix.gc.options = "--max-freed $((25 * 1024**3 - 1024 * $(df -P -k /nix/store | tail -n 1 | awk '{ print $4 }')))";

  users.knownGroups = [ "ofborg" ];
  users.knownUsers = [ "ofborg" ];

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 2;

  # You should generally set this to the total number of logical cores in your system.
  # $ sysctl -n hw.ncpu
  nix.maxJobs = 1;
  nix.buildCores = 1;
}