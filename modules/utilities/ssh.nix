{
  flake.nixosModules.ssh =
    { ... }:
    {
      programs.ssh.startAgent = true;
    };

  flake.homeModules.ssh =
    { pkgs, ... }:
    let
      onePassPath =
          "~/.1password/agent.sock";
    in
    {
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        matchBlocks."*" = {
          identityAgent = onePassPath;
        };
      };
    };
}
