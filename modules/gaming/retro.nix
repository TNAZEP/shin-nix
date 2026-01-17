{
  flake.nixosModules.retro =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        #Recomps
        shipwright 
        _2ship2harkinian
        perfect_dark

        #PC
        ironwail
      ];
    };
}

