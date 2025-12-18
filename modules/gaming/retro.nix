{
  flake.nixosModules.retro =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        # PC ports of classic games
        shipwright # Zelda: Ocarina of Time

        # Add more retro gaming tools here:
        # sm64coopdx     # Super Mario 64 co-op
        # _2ship2harkinian # Zelda: Majora's Mask
        # perfectdark    # Perfect Dark
      ];
    };
}

