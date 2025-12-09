{ config, ... }:
{
  flake.nixosModules.git =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        git
        gh
      ];
    };

  flake.darwinModules.git =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        git
        gh
      ];
    };

  flake.homeModules.git =
    { pkgs, ... }:
    let
      userSettings = config.meta.settings;
      filterAvailable = builtins.filter (pkgs.lib.meta.availableOn pkgs.stdenv.hostPlatform);

      sshSigner =
        if pkgs.stdenv.isDarwin then
          "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
        else
          "${pkgs.lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
    in
    {
      home.packages = filterAvailable [
        pkgs.github-desktop
      ];

      programs.git = {
        enable = true;
        settings = {
          user = {
            name = userSettings.name;
            email = userSettings.email;
            signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEclWROAzXXuA3fE8qIWW55pJLOewedBGS6bT6Sf3xG4";
          };

          "gpg \"ssh\"" = {
            program = sshSigner;
          };

          init.defaultBranch = "master";
          commit.gpgSign = true;
          gpg.format = "ssh";
        };
      };
    };
}
