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
    { pkgs, lib, ... }:
    let
      filterAvailable = builtins.filter (lib.meta.availableOn pkgs.stdenv.hostPlatform);

      sshSigner =
        if pkgs.stdenv.isDarwin then
          "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
        else
          lib.getExe' pkgs._1password-gui "op-ssh-sign";
    in
    {
      home.packages = filterAvailable [
        pkgs.github-desktop
      ];

      programs.git = {
        enable = true;
        userName = userSettings.name;
        userEmail = userSettings.email;
        signing = {
          key = userSettings.sshSigningKey;
          signByDefault = true;
        };
        extraConfig = {
          gpg.format = "ssh";
          "gpg \"ssh\"".program = sshSigner;
          init.defaultBranch = "master";
        };
      };
    };
}
