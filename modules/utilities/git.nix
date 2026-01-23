{ config, ... }:
let
  userSettings = config.meta.settings;

  # Shared git packages
  gitPackages = pkgs: with pkgs; [ git gh ];
in
{
  flake.nixosModules.git =
    { pkgs, ... }:
    {
      environment.systemPackages = gitPackages pkgs;
    };

  flake.darwinModules.git =
    { pkgs, ... }:
    {
      environment.systemPackages = gitPackages pkgs;
    };

  flake.homeModules.git =
    { pkgs, ... }:
    let
      filterAvailable = builtins.filter (pkgs.lib.meta.availableOn pkgs.stdenv.hostPlatform);
      sshSigner =
        if pkgs.stdenv.isDarwin
        then "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
        else "${pkgs.lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
    in
    {
      home.packages = filterAvailable [ pkgs.github-desktop ];

      programs.git = {
        enable = true;
        userName = userSettings.name;
        userEmail = userSettings.email;
        signing = {
          key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEclWROAzXXuA3fE8qIWW55pJLOewedBGS6bT6Sf3xG4";
          signByDefault = true;
        };
        extraConfig = {
          init.defaultBranch = "master";
          gpg.format = "ssh";
          "gpg \"ssh\"".program = sshSigner;
        };
      };
    };
}
