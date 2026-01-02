{
  flake.nixosModules.kdeMultimedia =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs.kdePackages; [
        # Music & Video
        elisa
        dragon
        ffmpegthumbs
        audiocd-kio

        # Image viewing
        gwenview
        kimageformats

        # Video editing
        kdenlive

        # Webcam
        kamoso
      ];
    };
}

