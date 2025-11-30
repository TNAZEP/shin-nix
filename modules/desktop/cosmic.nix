{
  flake.nixosModules.cosmic =
    { inputs, ... }:
    {
      services.desktopManager.cosmic.enable = true;
      services.displayManager.cosmic-greeter.enable = false;

      nix.settings = {
        substituters = [ "https://cosmic.cachix.org/" ];
        trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
      };

      # Disable gcr-ssh-agent to avoid conflict with programs.ssh.startAgent
      services.gnome.gcr-ssh-agent.enable = false;
    };

  flake.homeModules.cosmic =
    { ... }:
    {
    };
}
