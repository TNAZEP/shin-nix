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
    { pkgs, lib, ... }: 
    let
      onePassPath = if pkgs.stdenv.isDarwin 
        then "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
        else "~/.1password/agent.sock";
    in
    {
      programs.ssh = {
        enable = true;
        matchBlocks."*" = {
          identityAgent = onePassPath;
        };
      };
    };
}