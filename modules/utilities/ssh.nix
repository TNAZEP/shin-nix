{
  flake.nixosModules.ssh =
    { ... }:
    {
      programs.ssh.startAgent = true;
    };

  flake.darwinModules.ssh =
    { ... }:
    {
    };

  flake.homeModules.ssh =
    { ... }:
    {
      programs.ssh = {
        enable = true;
        matchBlocks."*" = {
          identityAgent = "~/.1password/agent.sock";
        };
      };
    };
}
